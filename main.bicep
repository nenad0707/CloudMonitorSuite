@description('Location for the resources.')
param location string

@description('Name for the Log Analytics workspace.')
param logAnalyticsName string

@description('Name for the Application Insights resource.')
param appInsightsName string

module logAnalyticsModule 'modules/logAnalytics.bicep' = {
  name: 'logAnalyticsDeploy'
  params: {
    location: location
    logAnalyticsName: logAnalyticsName
  }
}

module appInsightsModule 'modules/appInsights.bicep' = {
  name: 'appInsightsDeploy'
  params: {
    location: location
    appInsightsName: appInsightsName
    logAnalyticsWorkspaceId: logAnalyticsModule.outputs.workspaceId
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsModule.outputs.workspaceId
output applicationInsightsId string = appInsightsModule.outputs.appInsightsId
