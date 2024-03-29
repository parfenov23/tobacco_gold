class AddPgSearchDmetaphoneSupportFunctions < ActiveRecord::Migration[5.2]
  def self.up
    execute "create extension fuzzystrmatch;"
    say_with_time("Adding support functions for pg_search :dmetaphone") do
      execute <<-'SQL'
CREATE OR REPLACE FUNCTION pg_search_dmetaphone(text) RETURNS text LANGUAGE SQL IMMUTABLE STRICT AS $function$
  SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ')
$function$;
      SQL
    end
  end

  def self.down
    say_with_time("Dropping support functions for pg_search :dmetaphone") do
      execute <<-'SQL'
DROP FUNCTION pg_search_dmetaphone(text);
      SQL
    end
  end
end
