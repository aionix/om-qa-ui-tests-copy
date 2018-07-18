require 'clipboard'

def copy_string_to_clipboard(string)
  Clipboard.copy(string)
end

def clear_buffer
  Clipboard.clear
end