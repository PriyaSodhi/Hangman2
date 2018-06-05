class ClueBuilder
  def self.build_clue(word, guesses)
    word.chars.map do |letter|
      guesses.include?(letter.downcase) ? letter : nil
    end
  end
end