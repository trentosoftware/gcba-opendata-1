class String
  def to_ascii
    self.mb_chars.normalize(:kd).gsub(/[^x00-\x7F]/n, '').to_s
  end
end