@description('Location for the resources.')
param location string

@description('Name for the Log Analytics workspace.')
param logAnalyticsName string

@description('Name for the Application Insights resource.')
param appInsightsName string

@description('Name for the budget.')
param budgetName string  

@description('Amount for the monthly budget in USD.')
param budgetAmount int 

@description('Email addresses to notify when budget threshold is reached.')
param budgetEmails array = [
  ''
]

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

module budgetModule 'modules/budget.bicep' = {
  name: 'budgetDeploy'
  params: {
    budgetName: budgetName
    amount: budgetAmount 
    contactEmails: budgetEmails
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsModule.outputs.workspaceId
output applicationInsightsId string = appInsightsModule.outputs.appInsightsId
output budgetId string = budgetModule.outputs.budgetId
