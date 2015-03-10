USE [SP_Config];

SELECT 
		Name = CAST(o.Properties as XML).value('(/object/sFld[@name="_name"])[1]', 'nvarchar(255)'),
		ProjectDatabaseName_Draft = o_db_draft.Name,
		ProjectDatabaseName_Published = o_db_publish.Name,
		ProjectDatabaseName_Archive = o_db_archive.Name,
		ProjectDatabaseName_Reporting = o_db_reporting.Name,
		
		SharePointSiteId = CAST(o.Name as uniqueidentifier),
		SharePointWebAppId = CAST(o.Properties as XML).value('(/object/sFld[@name="_webAppId"])[1]', 'uniqueidentifier'),
		AdminName = CAST(o.Properties as XML).value('(/object/sFld[@name="_adminName"])[1]', 'nvarchar(255)'),
		LCID = CAST(o.Properties as XML).value('(/object/sFld[@name="_lcid"])[1]', 'int'),
		ProvisionStatus = CAST(o.Properties as XML).value('(/object/sFld[@name="_provisionStatusText"])[1]', 'nvarchar(255)'),
		
		Provisioned = CAST(o.Properties as XML).value('(/object/sFld[@name="_provisioned"])[1]', 'nvarchar(5)'),
		PostProvisionIncomplete = CAST(o.Properties as XML).value('(/object/sFld[@name="_postProvisionIncomplete"])[1]', 'nvarchar(5)'),
		ReportCenterProvisioned = CAST(o.Properties as XML).value('(/object/sFld[@name="_reportCenterProvisioned"])[1]', 'nvarchar(5)'),
		
		LastUpdatedTime = CAST(o.Properties as XML).value('(/object/sFld[@name="m_LastUpdatedTime"])[1]', 'nvarchar(255)')
FROM Classes c
JOIN Objects o
  ON o.ClassId = c.Id
LEFT JOIN Objects o_db_draft
  ON o_db_draft.Id = CAST(o.Properties as XML).value('(/object/fld[@name="_workingDatabase"])[1]', 'uniqueidentifier')
LEFT JOIN Objects o_db_publish
  ON o_db_publish.Id = CAST(o.Properties as XML).value('(/object/fld[@name="_publishedDatabase"])[1]', 'uniqueidentifier')
LEFT JOIN Objects o_db_archive
  ON o_db_archive.Id = CAST(o.Properties as XML).value('(/object/fld[@name="_versionsDatabase"])[1]', 'uniqueidentifier')
LEFT JOIN Objects o_db_reporting
  ON o_db_reporting.Id = CAST(o.Properties as XML).value('(/object/fld[@name="_reportingDatabase"])[1]', 'uniqueidentifier')
WHERE c.FullName like 'Microsoft.Office.Project.Server.Administration.ProjectSite, Microsoft.Office.Project.Server.Administration, Version=%'