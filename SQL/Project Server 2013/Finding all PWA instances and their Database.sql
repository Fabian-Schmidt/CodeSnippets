USE [SP_Config];

SELECT SiteId = CAST(o.Name as uniqueidentifier),
		Name = CAST(o.Properties as XML).value('(/object/sFld[@name="_name"])[1]', 'nvarchar(255)'),
		ProjectDatabaseName = o_db.Name
FROM Classes c
JOIN Objects o
  ON o.ClassId = c.Id
LEFT JOIN Objects o_db
  ON o_db.Id = CAST(o.Properties as XML).value('(/object/fld[@name="_projectServiceDatabase"])[1]', 'uniqueidentifier')
WHERE c.FullName like 'Microsoft.Office.Project.Server.Administration.ProjectSite, Microsoft.Office.Project.Server.Administration, Version=%'