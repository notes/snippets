#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/moduleparam.h> 
#include <linux/proc_fs.h>
#include <linux/ioctl.h>
#include <linux/sched.h>
#include <linux/vt.h>
#include <linux/workqueue.h>
#include <asm/uaccess.h>

#define SIOCADDRT 0x890B /* add routing table entry      */
#define SIOCDELRT 0x890C /* delete routing table entry   */
#define MIN(a,b) ((a)>(b)?(b):(a))
#define MAX(a,b) ((a)>(b)?(a):(b))

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Author Name");
MODULE_DESCRIPTION("This is a sample module.");

#define HELLO_WORLD "Hello, World!\n"
#define HELLO_DEVICE "hello_dev"
#define HELLO_PROC_NAME "hello_proc"
#define HELLO_TIMER_INTERVAL (HZ*30)
#define HELLO_WORKQ_NAME "hello_workq"

static int hello_major = -1;
static bool hello_busy = false;
static bool hello_shutdown = false;
static struct proc_dir_entry *hello_proc;
static struct timer_list hello_timer;
DECLARE_WAIT_QUEUE_HEAD(hello_wait_queue);
static void hello_work_func(void *p);
DECLARE_WORK(hello_work, hello_work_func, NULL);
static struct workqueue_struct *hello_workq = NULL;

static int hello_param = 0;
module_param(hello_param, int, S_IRUSR);
MODULE_PARM_DESC(hello_param, "A sample parameter");

static void hello_work_func(void *p)
{
    static unsigned int count = 0;
    printk(KERN_INFO "Workqueue Called (%u)\n", count++);
    if (!hello_shutdown) {
        queue_delayed_work(hello_workq, &hello_work, HELLO_TIMER_INTERVAL);
    }
}

static int hello_chrdev_open(struct inode *inode, struct file *file)
{
    try_module_get(THIS_MODULE);
    while (hello_busy) {
        wait_event_interruptible(hello_wait_queue, hello_busy == 0);
    }
    hello_busy = true;
    return 0;
}

static int hello_chrdev_release(struct inode *inode, struct file *file)
{
    hello_busy = 0;
    wake_up(&hello_wait_queue);
    module_put(THIS_MODULE);
    return 0;
}

static ssize_t hello_chrdev_read(struct file *file, char *buf, size_t len, loff_t *off)
{
    int i;
    for (i=0; i<len; i++) {
        put_user('x', buf++);
    }
    return len;
}

static ssize_t hello_chrdev_write(struct file *file, const char *str, size_t len, loff_t *off)
{
    return -EIO;
}

static int hello_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int ioctl_num, unsigned long ioctl_param)
{
    switch (ioctl_num) {
    case SIOCADDRT:
    case SIOCDELRT:
        printk(KERN_INFO "routing ioctl called\n");
        break;
    default:
        return -EINVAL;
    }

    return 0;
}

static struct file_operations hello_ops = {
    .open = hello_chrdev_open,
    .release = hello_chrdev_release,
    .read = hello_chrdev_read,
    .write = hello_chrdev_write,
    .ioctl = hello_chrdev_ioctl,
};

static ssize_t hello_proc_read(struct file *file, char *buf, size_t len, loff_t *off)
{
    unsigned long failed_len;
    ssize_t write_len = MIN(len, sizeof HELLO_WORLD - 1);

    if (*off > 0) {
        write_len = 0;
    } else {
        failed_len = copy_to_user(buf, HELLO_WORLD, write_len);
        if (failed_len > 0) {
            return -EFAULT;
        }
    }

    *off += write_len;
    return write_len;
}

static ssize_t hello_proc_write(struct file *file, const char *str, size_t len, loff_t *off)
{
    char buf[1024];
    unsigned long failed_len;

    len = MIN(len, sizeof buf);
    failed_len = copy_from_user(buf, str, len);
    if (failed_len > 0) {
        return -EFAULT;
    }

    printk(KERN_INFO "written %lu bytes to /proc/" HELLO_PROC_NAME "\n", (unsigned long)len);
    *off += len;
    return len;
}

static int hello_proc_open(struct inode *inode, struct file *file)
{
    try_module_get(THIS_MODULE);
    return 0;
}

static int hello_proc_release(struct inode *inode, struct file *file)
{
    module_put(THIS_MODULE);
    return 0;
}

static struct file_operations hello_proc_fops = {
    .open = hello_proc_open,
    .release = hello_proc_release,
    .read = hello_proc_read,
    .write = hello_proc_write,
};

static int hello_proc_perm(struct inode *inode, int op, struct nameidata *idata)
{
    if (op == 2 || op == 4) {
        if (current->euid == 0 || current->euid == 500) {
            return 0;
        }
    }
    return -EACCES;
}

static struct inode_operations hello_proc_iops = {
    .permission = hello_proc_perm,
};

static void hello_proc_init(void)
{
    hello_proc->proc_fops = &hello_proc_fops;
    hello_proc->proc_iops = &hello_proc_iops;
    hello_proc->owner = THIS_MODULE;
    hello_proc->mode = S_IFREG | S_IRUGO;
    hello_proc->uid = 0;
    hello_proc->gid = 0;
    hello_proc->size = 37;
}

static void hello_tick(unsigned long data)
{
    static unsigned int count = 0;
    printk(KERN_INFO "Timer Expired (%u)\n", count++);
    hello_timer.expires = jiffies + HELLO_TIMER_INTERVAL;
    add_timer(&hello_timer);
}

static int __init hello_init(void)
{
    hello_major = register_chrdev(0, HELLO_DEVICE, &hello_ops);
    if (hello_major < 0) {
        return -EINVAL;
    }

    hello_proc = create_proc_entry(HELLO_PROC_NAME, 0644, NULL);
    if (!hello_proc) {
        return -ENOMEM;
    }
    hello_proc_init();

    init_timer(&hello_timer);
    hello_timer.function = hello_tick;
    hello_timer.data = 0;
    hello_timer.expires = jiffies + HELLO_TIMER_INTERVAL;
    add_timer(&hello_timer);

    hello_workq = create_workqueue(HELLO_WORKQ_NAME);
    queue_delayed_work(hello_workq, &hello_work, HZ);

    printk(KERN_INFO "Hello, World!\n");
    return 0;
}

static void __exit hello_exit(void)
{
    int unreg_ret;

    del_timer(&hello_timer);
    remove_proc_entry(HELLO_PROC_NAME, &proc_root);

    unreg_ret = unregister_chrdev(hello_major, HELLO_DEVICE);
    if (unreg_ret < 0) {
        printk(KERN_INFO "Failed to unregister hello device\n");
    }

    hello_shutdown = true;
    cancel_delayed_work(&hello_work);
    flush_workqueue(hello_workq);
    destroy_workqueue(hello_workq);
    hello_workq = NULL;

    printk(KERN_INFO "Goodbye, World!\n");
}

module_init(hello_init);
module_exit(hello_exit);

