USE [SP_Config];

SELECT 
		Name = CAST(o.Properties as XML).value('(/object/sFld[@name="_name"])[1]', 'nvarchar(255)'),
		ProjectDatabaseName = o_db.Name,

		SharePointSiteId = CAST(o.Name as uniqueidentifier),
		SharePointWebAppId = CAST(o.Properties as XML).value('(/object/sFld[@name="_webAppId"])[1]', 'uniqueidentifier'),
		SharePointWebAppUsername = CAST(o.Properties as XML).value('(/object/sFld[@name="_webAppUsername"])[1]', 'nvarchar(255)'),
		AdminName = CAST(o.Properties as XML).value('(/object/sFld[@name="_adminName"])[1]', 'nvarchar(255)'),
		LCID = CAST(o.Properties as XML).value('(/object/sFld[@name="_lcid"])[1]', 'int'),
		ProvisionStatus = CAST(o.Properties as XML).value('(/object/fld[@name="_provisioningResult"])[1]', 'nvarchar(255)'),
		
		IsUpdating = CAST(o.Properties as XML).value('(/object/sFld[@name="_isUpdating"])[1]', 'nvarchar(5)'),
		ServiceDatabaseIsInReadOnlyMode = CAST(o.Properties as XML).value('(/object/sFld[@name="_serviceDatabaseIsInReadOnlyMode"])[1]', 'nvarchar(5)'),
		IsServiceDatabaseOverQuota = CAST(o.Properties as XML).value('(/object/sFld[@name="_isServiceDatabaseOverQuota"])[1]', 'nvarchar(5)'),
		IsDeleted = CAST(o.Properties as XML).value('(/object/sFld[@name="_isDeleted"])[1]', 'nvarchar(5)'),
		
		LastUpdatedTime = CAST(o.Properties as XML).value('(/object/sFld[@name="m_LastUpdatedTime"])[1]', 'nvarchar(255)')
FROM Classes c
JOIN Objects o
  ON o.ClassId = c.Id
LEFT JOIN Objects o_db
  ON o_db.Id = CAST(o.Properties as XML).value('(/object/fld[@name="_projectServiceDatabase"])[1]', 'uniqueidentifier')
WHERE c.FullName like 'Microsoft.Office.Project.Server.Administration.ProjectSite, Microsoft.Office.Project.Server.Administration, Version=%'