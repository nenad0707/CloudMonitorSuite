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

@description('Start date for the budget (ISO format, default: today)')
param budgetStartDate string

@description('Common tags for all resources.')
param tags object

@description('Name for the action group.')
param actionGroupName string

@description('Name for the alert rule.')
param alertRuleName string

module logAnalyticsModule 'modules/logAnalytics.bicep' = {
  name: 'logAnalyticsDeploy'
  params: {
    tags: tags
    location: location
    logAnalyticsName: logAnalyticsName
  }
}

module appInsightsModule 'modules/appInsights.bicep' = {
  name: 'appInsightsDeploy'
  params: {
    tags: tags
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
    startDate: budgetStartDate
  }
}

module actionGroupModule 'modules/actionGroup.bicep' = {
  name: 'actionGroupDeploy'
  params: {
    actionGroupName: actionGroupName
    emailReceivers: budgetEmails
  }
}

module alertModule 'modules/alert.bicep' = {
  name: 'alertDeploy'
  params: {
    alertRuleName: alertRuleName
    workspaceId: logAnalyticsModule.outputs.workspaceId
    actionGroupId: actionGroupModule.outputs.actionGroupId
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsModule.outputs.workspaceId
output applicationInsightsId string = appInsightsModule.outputs.appInsightsId
output budgetId string = budgetModule.outputs.budgetId
