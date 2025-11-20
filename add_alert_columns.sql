-- Add columns to alert table for storing sensor value and thresholds
-- Run this on VPS: docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -f /path/to/add_alert_columns.sql
-- Or run directly:
-- docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "ALTER TABLE public.alert ADD COLUMN IF NOT EXISTS type VARCHAR(255), ADD COLUMN IF NOT EXISTS value DOUBLE PRECISION, ADD COLUMN IF NOT EXISTS threshold_min DOUBLE PRECISION, ADD COLUMN IF NOT EXISTS threshold_max DOUBLE PRECISION;"

ALTER TABLE public.alert 
ADD COLUMN IF NOT EXISTS type VARCHAR(255),
ADD COLUMN IF NOT EXISTS value DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS threshold_min DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS threshold_max DOUBLE PRECISION;

