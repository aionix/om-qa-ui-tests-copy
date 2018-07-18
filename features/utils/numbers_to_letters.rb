def letter_sequence(n)
  n.to_s(26).each_char.map {|i| ('A'..'Z').to_a[i.to_i(26)]}.join
end


