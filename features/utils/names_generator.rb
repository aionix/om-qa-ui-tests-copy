### Names generator
def generate_project_name
  String project_name = "Auto #{DateTime.now.strftime('%F %T')}"
end

def generate_cur_date
  String ab = "#{DateTime.now.strftime('%m/%d/%Y')}"
end
