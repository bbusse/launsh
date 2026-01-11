# Show rss feeds
# Dependencies: vju, sqlite3, rss2x
# Utilizes the sqlite db of russ: https://github.com/ckampfe/russ
function rss() {
    local db_file
    db_file="${2}"
    local table_feeds
    table_feeds="${3}"
    local table_entries
    table_entries="${4}"

    local query_feeds
    query_feeds="SELECT title FROM ${table_feeds};"

    local r

    local feeds
    feeds=$(sqlite3 -separator " " "${db_file}" "${query_feeds}")
    r=$(printf "%s\n" "${feeds}" | vju --type select --width=420 --font-size 12)
    if [ "${r}" = "vju-exit" ]; then
        return 0
    fi

    local query_feed_id
    query_feed_id="SELECT id FROM ${table_feeds} WHERE title='${r}';"

    local feed_id
    feed_id=$(sqlite3 -separator " " "${db_file}" "${query_feed_id}")

    r=$(rss_show_entries "${db_file}" "${table_entries}" "${feed_id}")
    if [ "${r}" = "vju-exit" ]; then
        exit 0
    elif [ "${r}" = "vju-read" ]; then
        rss_mark_as_read "${db_file}" "${table_entries}" "${entry_title}"
        rss_show_entries "${db_file}" "${table_entries}" "${feed_id}"
    fi
    printf "%s\n" "${r}"

    r=$(rss_show_content "${db_file}" "${table_entries}" "${entry_title}")
    if [ "${r}" = "vju-exit" ]; then
        return 0
    elif [ "${r}" = "vju-read" ]; then
        rss_mark_as_read "${db_file}" "${table_entries}" "${entry_title}"
        rss_show_entries "${db_file}" "${table_entries}" "${feed_id}"
        rss_show_content "${db_file}" "${table_entries}" "${entry_title}"
    fi
}

# Show rss entry content
function rss_show_content() {
    local db_file
    db_file="${1}"
    local table_entries
    table_entries="${2}"
    local entry_title
    entry_title="${3}"

    local entry_title
    entry_title="${entry_title//\'/''}"

    local query_entry_content
    query_entry_content="SELECT content FROM ${table_entries} WHERE title='${entry_title}';"

    local content
    content=$(sqlite3 -separator " " "${db_file}" "${query_entry_content}")

    r=$(printf "%s\n" "${content}" | rss2x | vju --return-keys r --width=600 --font-size 12)
    echo "${r}"
}

# Show rss entries for a feed
function rss_show_entries() {
    local query_entries
    query_entries="SELECT title FROM ${table_entries} WHERE feed_id='${feed_id}' AND (read_at IS NULL OR read_at = '') ORDER BY pub_date DESC;"

    local entries
    entries=$(sqlite3 -separator " " "${db_file}" "${query_entries}")

    local r
    r=$(printf "%s\n" "${entries}" | vju --type select --width=600 --font-size 12)
    echo "${r}"
}

# Mark rss entry as read
function rss_mark_as_read() {
    local db_file
    db_file="${1}"
    local table_entries
    table_entries="${2}"
    local entry_title
    entry_title="${3}"

    # Escape single quotes for SQLite
    local entry_title
    entry_title="${entry_title//\'/''}"

    local query_read_at
    query_read_at="UPDATE ${table_entries} SET read_at = (strftime('%Y-%m-%d %H:%M:%f','now') || '+00:00') WHERE title = '${entry_title}';"

    sqlite3 -separator " " "${db_file}" "${query_read_at}"
    if [ $? -eq 0 ]; then
        printf "Marked as read\n"
        printf "%s\n" "${query_read_at}"
    else
        printf "Failed to mark as read\n" >&2
    fi
}

# Schema of the russ sqlite db:
function rss_schema_create() {
	local query
    query="
	CREATE TABLE feeds (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			title TEXT,
			feed_link TEXT,
			link TEXT,
			feed_kind TEXT,
			refreshed_at TIMESTAMP,
			inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
			, latest_etag TEXT);
	CREATE TABLE sqlite_sequence(name,seq);
	CREATE TABLE entries (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			feed_id INTEGER,
			title TEXT,
			author TEXT,
			pub_date TIMESTAMP,
			description TEXT,
			content TEXT,
			link TEXT,
			read_at TIMESTAMP,
			inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
			);
	CREATE INDEX entries_feed_id_and_pub_date_and_inserted_at_index
			ON entries (feed_id, pub_date, inserted_at);
	CREATE UNIQUE INDEX feeds_feed_link ON feeds (feed_link);"

    printf "%s\n" "${query}"
}
