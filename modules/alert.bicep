@description('Name for the alert rule.')
param alertRuleName string

@description('Resource ID of the Log Analytics workspace.')
param workspaceId string

@description('Resource ID of the action group.')
param actionGroupId string

resource metricAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: alertRuleName
  location: 'global'
  properties: {
    description: 'Alert when ingestion is over 1GB'
    severity: 3
    enabled: true
    scopes: [
      workspaceId
    ]
    evaluationFrequency: 'PT1H'
    windowSize: 'PT1H'
   criteria: {
  'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
  allOf: [
    {
      criterionType: 'StaticThresholdCriterion'
      name: 'IngestionThreshold'
      metricName: 'Total Ingested Volume'
      metricNamespace: 'Microsoft.OperationalInsights/workspaces'
      operator: 'GreaterThan'
      threshold: 1
      timeAggregation: 'Total'
      dimensions: []
    }
  ]
}

    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
    autoMitigate: true
  }
}

output alertId string = metricAlert.id
