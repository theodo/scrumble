ALTER TABLE dailyReportPing ADD COLUMN projectId integer references project(id);
