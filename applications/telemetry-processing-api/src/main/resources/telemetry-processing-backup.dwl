
%dw 2.0
output application/json

var telemetry = payload

fun classify(metric, value) =
    do {
        var metricName = upper(metric)
        var readingValue = value as Number
        var minValue = Mule::p("metrics." ++ metricName ++ ".min") as Number
        var maxValue = Mule::p("metrics." ++ metricName ++ ".max") as Number
        var warningValue = Mule::p("metrics." ++ metricName ++ ".warning") as Number
        var criticalValue = Mule::p("metrics." ++ metricName ++ ".critical") as Number
        ---
        if (readingValue < minValue or readingValue > maxValue)
            "OUT_OF_RANGE"
        else if (readingValue >= criticalValue)
            "CRITICAL"
        else if (readingValue >= warningValue)
            "WARNING"
        else
            "NORMAL"
    }

---
{
    deviceId: telemetry.deviceId,
    siteId: telemetry.siteId,
    firmwareVersion: telemetry.firmwareVersion,
    batchId: telemetry.batchId,
    correlationId: telemetry.correlationId,

    readings: telemetry.readings map (reading) -> {
        metricName: reading.metricName,
        value: reading.value,
        unit: reading.unit,
        readingTimestamp: reading.readingTimestamp,
        quality: reading.quality,
        status: classify(reading.metricName, reading.value)
    },

    readingCount: sizeOf(telemetry.readings),
    processingStatus: "PROCESSED",
    processedAt: now()
}
