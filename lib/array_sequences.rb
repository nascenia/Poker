class Array
  def sequences
    a = sort.uniq.inject([]){|key, e|
      key.last && e == key.last.last + 1 ? key.last.push(e) : key.push([e])
      key
    }
    a.push([*a.pop, *a.shift]) if a.first.first == 1 && a.last.last == 13
    a
  end
end