@description('Location for the Application Insights resource.')
param location string

@description('Name for the Application Insights resource.')
param appInsightsName string = 'cloudMonitor-ai'

@description('The ID of the Log Analytics workspace to link with Application Insights.')
param logAnalyticsWorkspaceId string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
    RetentionInDays: 30
    DisableIpMasking: false
  }
}

output appInsightsId string = appInsights.id
