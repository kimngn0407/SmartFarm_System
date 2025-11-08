#!/bin/bash

# Script kiểm tra số lượng records trong database
# Usage: ./check-database-data.sh

echo "=== Kiểm tra số lượng records trong các bảng ==="
echo ""

# Danh sách các bảng cần kiểm tra
TABLES=(
    "account"
    "account_roles"
    "alert"
    "coordinates"
    "crop_growth_stage"
    "crop_season"
    "farm"
    "fertilization_history"
    "field"
    "harvest"
    "irrigation_history"
    "plant"
    "sensor"
    "sensor_data"
    "sensor_node"
    "warning_threshold"
)

echo "Bảng | Số lượng records"
echo "------|-----------------"

for table in "${TABLES[@]}"; do
    count=$(docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM $table;" 2>/dev/null | xargs)
    printf "%-30s | %s\n" "$table" "$count"
done

echo ""
echo "=== Tổng kết ==="
total=$(docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -t -c "
SELECT SUM(
    (SELECT COUNT(*) FROM account) +
    (SELECT COUNT(*) FROM farm) +
    (SELECT COUNT(*) FROM field) +
    (SELECT COUNT(*) FROM sensor) +
    (SELECT COUNT(*) FROM sensor_data)
);" 2>/dev/null | xargs)

echo "Tổng số records (account + farm + field + sensor + sensor_data): $total"


