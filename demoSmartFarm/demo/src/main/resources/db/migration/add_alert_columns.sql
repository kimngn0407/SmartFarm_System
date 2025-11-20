-- Add columns to alert table for storing sensor value and thresholds
ALTER TABLE public.alert 
ADD COLUMN IF NOT EXISTS type VARCHAR(255),
ADD COLUMN IF NOT EXISTS value DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS threshold_min DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS threshold_max DOUBLE PRECISION;

