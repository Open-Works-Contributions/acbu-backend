-- CreateIndex
CREATE INDEX IF NOT EXISTS "idx_on_ramp_swap_status_created_at"
ON "on_ramp_swaps"("status", "created_at");
