# terminal logger class from gd-plug

class_name Logger extends RefCounted

enum LogLevel {
	ALL, DEBUG, INFO, WARN, ERROR, NONE
}
const DEFAULT_LOG_FORMAT_DETAIL = "[{time}] [{level}] {msg}"
const DEFAULT_LOG_FORMAT_NORMAL = "{msg}"

var log_level = LogLevel.INFO
var log_format = DEFAULT_LOG_FORMAT_NORMAL
var log_time_format = "{year}/{month}/{day} {hour}:{minute}:{second}"
var indent_level = 0
var is_locked = false

var _rows
var _max_column_length = []
var _max_column_size = 0

func debug(msg, raw=false):
	_log(LogLevel.DEBUG, msg, raw)

func info(msg, raw=false):
	_log(LogLevel.INFO, msg, raw)

func warn(msg, raw=false):
	_log(LogLevel.WARN, msg, raw)

func error(msg, raw=false):
	_log(LogLevel.ERROR, msg, raw)

func _log(level, msg, raw=false):
	if is_locked:
		return
	
	if typeof(msg) != TYPE_STRING:
		msg = str(msg)
	if log_level <= level:
		match level:
			LogLevel.WARN:
				push_warning(format_log(level, msg))
			LogLevel.ERROR:
				push_error(format_log(level, msg))
			_:
				if raw:
					printraw(format_log(level, msg))
				else:
					print(format_log(level, msg))

func format_log(level, msg):
	return log_format.format({
		"time": log_time_format.format(get_formatted_datatime()),
		"level": LogLevel.keys()[level],
		"msg": msg.indent("    ".repeat(indent_level))
	})

func indent():
	indent_level += 1

func dedent():
	indent_level -= 1
	max(indent_level, 0)

func lock():
	is_locked = true

func unlock():
	is_locked = false

func table_start():
	_rows = []

func table_end():
	assert(_rows != null, "Expected table_start() to be called first")
	for columns in _rows:
		var text = ""
		for i in columns.size():
			var column = columns[i]
			var max_tab_count = ceil(float(_max_column_length[i]) / 4.0)
			var tab_count = max_tab_count - ceil(float(column.length()) / 4.0)
			var extra_spaces = ceil(float(column.length()) / 4.0) * 4 - column.length()
			if i < _max_column_size - 1:
				text += column + " ".repeat(extra_spaces) + "    ".repeat(tab_count)
			else:
				text += column
		info(text)
	
	_rows.clear()
	_rows = null
	_max_column_length.clear()
	_max_column_size = 0

func table_row(columns=[]):
	assert(_rows != null, "Expected table_start() to be called first")
	_rows.append(columns)
	_max_column_size = max(_max_column_size, columns.size())
	for i in columns.size():
		var column = columns[i]
		if _max_column_length.size() >= i + 1:
			var max_column_length = _max_column_length[i]
			_max_column_length[i] = max(max_column_length, column.length())
		else:
			_max_column_length.append(column.length())

func get_formatted_datatime():
	var datetime = Time.get_datetime_dict_from_system()
	datetime.year = "%04d" % datetime.year
	datetime.month = "%02d" % datetime.month
	datetime.day = "%02d" % datetime.day
	datetime.hour = "%02d" % datetime.hour
	datetime.minute = "%02d" % datetime.minute
	datetime.second = "%02d" % datetime.second
	return datetime
