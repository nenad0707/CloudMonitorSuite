
@description('Loacation for the Application Insights resource.')
param location string

@description('The ID of the Log Analytics workspace to link with Application Insights.')
param logAnalyticsWorkspaceId string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'cloudMonitor-ai'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
    IngestionMode: 'ApplicationInsights'
    RetentionInDays: 90
    DisableIpMasking: false
  }
}

output appInsightsId string = appInsights.id
