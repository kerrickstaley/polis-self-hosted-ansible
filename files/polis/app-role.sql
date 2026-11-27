\getenv app_password APP_PASSWORD
CREATE ROLE polis_app LOGIN PASSWORD :'app_password';
GRANT USAGE ON SCHEMA public TO polis_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO polis_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO polis_app;
REVOKE INSERT, UPDATE, DELETE ON public.migrations FROM polis_app;
