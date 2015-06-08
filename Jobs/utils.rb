def prompt(default, *args)
  print(*args)
  result = gets.strip
  return result.empty? ? default : result
end