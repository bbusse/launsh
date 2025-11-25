# module podcasts
# Listen to podcasts
# Dependencies: shellcaster, sqlite3, mpv, curl
podcasts() {
    local db_file
    db_file="${2}"
    local table_podcasts
    table_podcasts="${3}"
    local table_episodes
    table_episodes="${4}"
    local table_files
    table_files="${5}"

    local query_podcasts
    query_podcasts="SELECT title FROM '${table_podcasts}';"

    local podcasts
    podcasts=$(sqlite3 -separator " " "${db_file}" "${query_podcasts}")

    local podcast_title
    podcast_title=$(printf "%s\n" "${podcasts}" | vju --type select --width=420 --font-size 12)

    local query_podcast_id
    query_podcast_id="SELECT id FROM '${table_podcasts}' WHERE title='${podcast_title}';"

    local podcast_id
    podcast_id=$(sqlite3 -separator " " "${db_file}" "${query_podcast_id}")

    local query_episodes
    query_episodes="SELECT title FROM '${table_episodes}' WHERE podcast_id='${podcast_id}';"

    r=$(sqlite3 -separator " " "${db_file}" "${query_episodes}")

    local episode_title
    episode_title=$(printf "%s\n" "${r}" | vju --type select --width=420 --font-size 12)

    if [ -z "${episode_title}" ]; then
        return
    fi

    local query_episode_id
    query_episode_id="SELECT id FROM '${table_episodes}' WHERE title='${episode_title}';"

    local episode_id
    episode_id=$(sqlite3 -separator " " "${db_file}" "${query_episode_id}")

    local query_episode_file
    query_episode_file="SELECT path FROM '${table_files}' WHERE episode_id='${episode_id}';"

    local episode_file
    episode_file=$(sqlite3 -separator " " "${db_file}" "${query_episode_file}")

    # Download if file does not exist
    if [ -z "${episode_file}" ]; then
        local query_episode_url
        query_episode_url="SELECT url FROM '${table_episodes}' WHERE id='${episode_id}'";

        local episode_url
        episode_url=$(sqlite3 -separator " " "${db_file}" "${query_episode_url}")

        local path
        path="${HOME}/.local/share/shellcaster/${podcast_title}/"

        local episode_file
        episode_file="${episode_url##*/}"

        mkdir -p "${path}"
        curl -o "${path}/${episode_file}" -LO "${episode_url}"
    fi

    mpv "${path}"/"${episode_file}"
}

# Schema of the shellcaster sqlite db:
function podcasts_schema_create() {
	local query
    query="
	CREATE TABLE podcasts (
					id INTEGER PRIMARY KEY NOT NULL,
					title TEXT NOT NULL,
					url TEXT NOT NULL UNIQUE,
					description TEXT,
					author TEXT,
					explicit INTEGER,
					last_checked INTEGER
				);
	CREATE TABLE episodes (
					id INTEGER PRIMARY KEY NOT NULL,
					podcast_id INTEGER NOT NULL,
					title TEXT NOT NULL,
					url TEXT NOT NULL,
					guid TEXT,
					description TEXT,
					pubdate INTEGER,
					duration INTEGER,
					played INTEGER,
					hidden INTEGER,
					FOREIGN KEY(podcast_id) REFERENCES podcasts(id) ON DELETE CASCADE
				);
	CREATE TABLE files (
					id INTEGER PRIMARY KEY NOT NULL,
					episode_id INTEGER NOT NULL,
					path TEXT NOT NULL UNIQUE,
					FOREIGN KEY (episode_id) REFERENCES episodes(id) ON DELETE CASCADE
				);
	CREATE TABLE version (
					id INTEGER PRIMARY KEY NOT NULL,
					version TEXT NOT NULL
				);"
}
