experience = {'HW/SW Test Designer' => 7,
              'AXE SW Designer' => 6,
              'FLS OSS' => 4,
              'PM/FI/NRO BSS, FI/NRO/SLS/SI OSS' => 2}
experience_total = 0
experience.each_value {|a_value| experience_total += a_value}
puts experience_total 
