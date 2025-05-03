-- 1. SQL Commands to create tables:

-- Table: public.gps_data
-- DROP TABLE IF EXISTS public.gps_data;
CREATE TABLE IF NOT EXISTS public.gps_data
(
    gps_id integer NOT NULL DEFAULT nextval('gps_data_gps_id_seq'::regclass),
    video_id integer,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT gps_data_pkey PRIMARY KEY (gps_id),
    CONSTRAINT gps_data_video_id_fkey FOREIGN KEY (video_id)
        REFERENCES public.videos (video_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.gps_data
    OWNER to postgres;


-- Table: public.weather_data
-- DROP TABLE IF EXISTS public.weather_data;
CREATE TABLE IF NOT EXISTS public.weather_data
(
    weather_id integer NOT NULL DEFAULT nextval('weather_data_weather_id_seq'::regclass),
    gps_id integer,
    temperature double precision NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT weather_data_pkey PRIMARY KEY (weather_id),
    CONSTRAINT unique_gps_id UNIQUE (gps_id),
    CONSTRAINT weather_data_gps_id_fkey FOREIGN KEY (gps_id)
        REFERENCES public.gps_data (gps_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.weather_data
    OWNER to postgres;


-- Table: public.videos
-- DROP TABLE IF EXISTS public.videos;
CREATE TABLE IF NOT EXISTS public.videos
(
    video_id integer NOT NULL DEFAULT nextval('videos_video_id_seq'::regclass),
    video_url text COLLATE pg_catalog."default" NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    location_data jsonb,
    CONSTRAINT videos_pkey PRIMARY KEY (video_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.videos
    OWNER to postgres;


-- Table: public.test_results
-- DROP TABLE IF EXISTS public.test_results;
CREATE TABLE IF NOT EXISTS public.test_results
(
    gps_id integer NOT NULL,
    flag text COLLATE pg_catalog."default",
    visual_cue text COLLATE pg_catalog."default",
    risk_reason text COLLATE pg_catalog."default",
    CONSTRAINT test_results_pkey PRIMARY KEY (gps_id),
    CONSTRAINT test_results_gps_id_fkey FOREIGN KEY (gps_id)
        REFERENCES public.gps_data (gps_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT test_results_test_result_check CHECK (flag = ANY (ARRAY['Dehydrated'::text, 'Normal'::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.test_results
    OWNER to postgres;

--------------------------------------------------------------------------------
-- 2. Commands to View Table Data: 
-- Once the tables are created and populated, you can run the following in your psql shell to see what’s inside:

-- View GPS data
SELECT * FROM gps_data;

-- View Weather data
SELECT * FROM weather_data;

-- View Test Results
SELECT * FROM test_results;

--------------------------------------------------------------------------------