# Prom QL Tricks #

Capturing my Prom QL learnings here for future reference.

## Setting Variable and filter options ##

When creating variables you can define variables in dashboard settings. You can then use the variable in QL like `$var`

Here is an example
```
sum by(itemId)(sum_over_time(one_tracking_total{_namespace_="namespace_org",channel=~"$channel",action=~"send",itemId!="null"}[$granularity]))
```
