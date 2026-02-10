-- ==============================================
-- ConciliaSII - Schema para Supabase
-- Ejecutar en el SQL Editor de Supabase
-- ==============================================

-- 1. Tabla de conciliaciones (cada vez que ejecutas una)
CREATE TABLE conciliaciones (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  nombre TEXT NOT NULL DEFAULT 'Sin nombre',
  periodo TEXT, -- ej: "2026-01", "Enero 2026"
  total_documentos INT DEFAULT 0,
  total_conciliados INT DEFAULT 0,
  total_sin_pago INT DEFAULT 0,
  total_sin_factura INT DEFAULT 0,
  monto_total NUMERIC(15,2) DEFAULT 0,
  monto_conciliado NUMERIC(15,2) DEFAULT 0,
  monto_sin_pago NUMERIC(15,2) DEFAULT 0,
  monto_sin_factura NUMERIC(15,2) DEFAULT 0,
  configuracion JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Detalle de cada registro de la conciliación
CREATE TABLE conciliacion_detalles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  conciliacion_id UUID REFERENCES conciliaciones(id) ON DELETE CASCADE NOT NULL,
  estado TEXT NOT NULL CHECK (estado IN ('matched', 'unmatched-sii', 'unmatched-bank')),
  -- Datos SII
  sii_rut TEXT,
  sii_razon_social TEXT,
  sii_folio TEXT,
  sii_fecha DATE,
  sii_monto NUMERIC(15,2),
  sii_tipo TEXT,
  -- Datos Banco
  bank_fecha DATE,
  bank_descripcion TEXT,
  bank_monto NUMERIC(15,2),
  -- Match info
  match_manual BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Índices
CREATE INDEX idx_conciliaciones_user ON conciliaciones(user_id);
CREATE INDEX idx_conciliaciones_created ON conciliaciones(created_at DESC);
CREATE INDEX idx_detalles_conciliacion ON conciliacion_detalles(conciliacion_id);
CREATE INDEX idx_detalles_estado ON conciliacion_detalles(estado);

-- 4. Row Level Security (RLS) - Cada usuario solo ve sus datos
ALTER TABLE conciliaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE conciliacion_detalles ENABLE ROW LEVEL SECURITY;

-- Políticas para conciliaciones
CREATE POLICY "Users can view own conciliaciones"
  ON conciliaciones FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own conciliaciones"
  ON conciliaciones FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own conciliaciones"
  ON conciliaciones FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own conciliaciones"
  ON conciliaciones FOR DELETE
  USING (auth.uid() = user_id);

-- Políticas para detalles (a través de la conciliación padre)
CREATE POLICY "Users can view own detalles"
  ON conciliacion_detalles FOR SELECT
  USING (
    conciliacion_id IN (
      SELECT id FROM conciliaciones WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own detalles"
  ON conciliacion_detalles FOR INSERT
  WITH CHECK (
    conciliacion_id IN (
      SELECT id FROM conciliaciones WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own detalles"
  ON conciliacion_detalles FOR UPDATE
  USING (
    conciliacion_id IN (
      SELECT id FROM conciliaciones WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own detalles"
  ON conciliacion_detalles FOR DELETE
  USING (
    conciliacion_id IN (
      SELECT id FROM conciliaciones WHERE user_id = auth.uid()
    )
  );

-- 5. Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER conciliaciones_updated_at
  BEFORE UPDATE ON conciliaciones
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
