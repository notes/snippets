#!/usr/bin/python
# coding: utf-8

import sys
import re
import array
import mms.mms_pdu as mms
import mms.wsp_pdu as wsp

class MIBEnum:
  ASCII = 3
  ISO_8859_1 = 4
  SHIFT_JIS = 17
  ISO_2022_JP = 39
  UTF8 = 106

ResponseStatus = {
  0x80 : 'Ok',
  0x81 : 'Error-unspecified',
  0x82 : 'Error-service-denied',
  0x83 : 'Error-message-format-corrupt',
  0x84 : 'Error-sending-address-unresolved',
  0x85 : 'Error-message-not-found',
  0x86 : 'Error-network-problem',
  0x87 : 'Error-content-not-accepted',
  0x88 : 'Error-unsupported-message',
  0xC0 : 'Error-transient-failure',
  0xC1 : 'Error-transient-sending-address-unresolved',
  0xC2 : 'Error-transient-message-not-found',
  0xC3 : 'Error-transient-network-problem',
  0xC4 : 'Error-transient-partial-success',
  0xE0 : 'Error-permanent-failure',
  0xE1 : 'Error-permanent-service-denied',
  0xE2 : 'Error-permanent-message-format-corrupt',
  0xE3 : 'Error-permanent-sending-address-unresolved',
  0xE4 : 'Error-permanent-message-not-found',
  0xE5 : 'Error-permanent-content-not-accepted',
  0xE6 : 'Error-permanent-reply-charging-limitations-not-met',
  0xE7 : 'Error-permanent-reply-charging-request-not-accepted',
  0xE8 : 'Error-permanent-reply-charging-forwarding-denied',
  0xE9 : 'Error-permanent-reply-charging-not-supported',
  0xEA : 'Error-permanent-address-hiding-not-supported',
  0xEB : 'Error-permanent-lack-of-prepaid',
}

EncodeMethods = (
  ("EncodedStringValue", ("bcc", "cc", "x-mms-response-text", "subject", "to")),
  ("TextString", ("message-id", "x-mms-transaction-id")),
  ("VersionValue", ("x-mms-version",)),
  ("IntegerValue", ("x-mms-limit", "x-mms-message-count", "x-mms-start")),
  ("LongIntegerValue", ("date", "x-mms-message-size")),
  ("BooleanValue", ("x-mms-delivery-report", "x-mms-read-reply", "x-mms-report-allowed")),
  ("ContentTypeValue", ("content-type",)),
)

FieldNames = (
  None,
  "bcc",
  "cc",
  "x-mms-content-location",
  "content-type",
  "date",
  "x-mms-delivery-report",
  "x-mms-delivery-time",
  "x-mms-expiry",
  "from",
  "x-mms-message-class",
  "message-id",
  "x-mms-message-type",
  "x-mms-mms-version",
  "x-mms-message-size",
  "x-mms-priority",
  "x-mms-read-report",
  "x-mms-report-allowed",
  "x-mms-response-status",
  "x-mms-response-text",
  "x-mms-sender-visibility",
  "x-mms-status",
  "subject",
  "to",
  "x-mms-transaction-id",
  "x-mms-retrieve-status",
  "x-mms-retrieve-text",
  "x-mms-read-status",
  "x-mms-reply-charging",
  "x-mms-reply-charging-deadline",
  "x-mms-reply-charging-id",
  "x-mms-reply-charging-size",
  "x-mms-previously-sent-by",
  "x-mms-previously-sent-date",
  "x-mms-store",
  "x-mms-mm-state",
  "x-mms-mm-flags",
  "x-mms-store-status",
  "x-mms-store-status-text",
  "x-mms-stored",
  "x-mms-attributes",
  "x-mms-totals",
  "x-mms-mbox-totals",
  "x-mms-quotas",
  "x-mms-mbox-quotas",
  "x-mms-message-count",
  "content",
  "x-mms-start",
  "additional-headers",
  "x-mms-distribution-indicator",
  "x-mms-element-descriptor",
  "x-mms-limit",
  "x-mms-recommended-retrieval-mode",
  "x-mms-recommended-retrieval-mode-text",
  "x-mms-status-text",
  "x-mms-applic-id",
  "x-mms-reply-applic-id",
  "x-mms-aux-applic-info",
  "x-mms-content-class",
  "x-mms-drm-content",
  "x-mms-adaptation-allowed",
  "x-mms-replace-id",
  "x-mms-cancel-id",
  "x-mms-cancel-status",
)

FieldNamesDict = {}
for i, name in enumerate(FieldNames):
  if name:
    FieldNamesDict[name] = i

# Header-field = MMS-header | Application-header
# MMS-header = MMS-field-name MMS-value
# Application-header = Token-text Application-specific-value
# Token-text = Token End-of-string
# MMS-field-name = Short-integer
# Application-specific-value = Text-string
class Encoder(object):
  @staticmethod
  def isWellKnownField(field_name):
    return FieldNamesDict.has_key(field_name.lower())

  @staticmethod
  def fieldNum(field_name):
    return FieldNamesDict[field_name.lower()]

  @staticmethod
  def headerField(field_name, field_value):
    data = []
    data.extend(Encoder.fieldName(field_name))
    data.extend(Encoder.fieldValue(field_name, field_value))
    return data

  @staticmethod
  def encodedStringValue(string):
    data = []
    #data.extend(wsp.Encoder.encodeValueLength(len(string) + 1))
    #data.append(MIBEnum.UTF8)
    data.extend(wsp.Encoder.encodeTextString(string))
    return data

  @staticmethod
  def fromValue(from_value=""):
    data = []
    if len(from_value) == 0:
      data.extend(wsp.Encoder.encodeValueLength(1))
      data.append(129)
    else:
      from_addr = Encoder.encodedStringValue(from_value)
      value_length = wsp.Encoder.encodeValueLength(len(from_addr) + 1)
      data.extend(value_length)
      data.append(128)
      data.extend(from_addr)
    return data

  @staticmethod
  def fieldValue(field_name, field_value):
    field_name = field_name.lower()
    data = []
    for m in EncodeMethods:
      if field_name in m[1]:
        if m[0] == "EncodedTextString":
          data.extend(Encoder.encodedTextString(field_value))
        else:
          exec 'data.extend(wsp.Encoder.encode%s(field_value))' % m[0]
        break
    else:
      data.extend(wsp.Encoder.encodeTextString(field_value))
    return data
     
  @staticmethod
  def fieldName(field_name):
    if Encoder.isWellKnownField(field_name):
      field_num = Encoder.fieldNum(field_name)
      return wsp.Encoder.encodeShortInteger(field_num)
    else:
      return wsp.Encoder.encodeTokenText(field_name)


if __name__ == "__main__":
  intlist = Encoder.headerField("From", "foo")
  data = array.array('B')
  data.extend(intlist)
  sys.stdout.write(data.tostring())
  sys.exit(0)


