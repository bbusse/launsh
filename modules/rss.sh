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
    query_feeds="SELECT title FROM '$table_feeds';"

    local r
    r=$(sqlite3 -separator " " "${db_file}" "${query_feeds}")
    r=$(printf "%s\n" "${r}" | vju --type select --width=420 --font-size 12)

    local query_feed_id
    query_feed_id="SELECT id FROM $table_feeds WHERE title='$r';"

    local feed_id
    feed_id=$(sqlite3 -separator " " "${db_file}" "${query_feed_id}")

    local query_entries
    query_entries="SELECT title FROM $table_entries WHERE feed_id='$feed_id';"

    local entries
    entries=$(sqlite3 -separator " " "${db_file}" "${query_entries}")
    entry_title=$(printf "%s\n" "${entries}" | vju --type select --width=600 --font-size 12)

    local query_entry_content
    query_entry_content="SELECT content FROM $table_entries WHERE title='$entry_title';"

    local content
    content=$(sqlite3 -separator " " "${db_file}" "${query_entry_content}")
    content=$(printf "%s\n" "${content}" | rss2x | vju --width=600 --font-size 12)
}
