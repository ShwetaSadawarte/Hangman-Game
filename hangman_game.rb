class HangMan

  MAX_NUMBER_OF_GUESSES = 6

  def initialize(user_input = UserInput.new, word_to_guess = choose_random_word)
    @word_to_guess = word_to_guess
    @user_input = user_input
    @number_of_wrong_guesses = 0
    @dash_array = init_dash_array
  end

  def init_dash_array
    dash_array = Array.new

    (0..@word_to_guess.length-1).each do |i|
      dash_array.push '_'
    end

    dash_array
  end

  def choose_random_word
    dictionary = File.read('dictionary.txt').split("\n")
    dictionary[rand(dictionary.length)].chomp
  end

  def play_game
    while !is_lost && !is_won do
      game_round()
    end
    puts @number_of_wrong_guesses == MAX_NUMBER_OF_GUESSES ? 'sorry...' : 'Congrats'
    try_again
  end

  def is_won
    !@dash_array.find_index('_')
  end

  def is_lost
    @number_of_wrong_guesses >= MAX_NUMBER_OF_GUESSES
  end

  def try_again
    puts "Try again (y/n)?"
    try_again = gets.chomp
    (try_again == "y" || try_again == "Y")? HangMan.new.play_game : 'Bye'
  end

  def game_round
    puts "#{@dash_array.join ' '}"
    guess = @user_input.get_input

    if @word_to_guess.include?(guess)
      (0 .. @word_to_guess.length - 1).each do |i|
        position = @word_to_guess.index(guess, i)
        if position != nil
          @dash_array[position] = guess
        end
      end
    else
      @number_of_wrong_guesses += 1
      puts "Wrong Guess count = #{@number_of_wrong_guesses}"
      hangman_picture()
    end
  end

end

class UserInput
  def get_input
    begin
      puts 'guess a letter'
      input = gets.chomp
    end until input =~ /^[a-z]$/
    input
  end
end

def hangman_picture
  case @number_of_wrong_guesses
    when 1
      puts "
      \t|---
      \t|  O
      \t|  |/
      \t|
      \t|
      \t|_____"
    when 2
      puts "
      \t|---
      \t|  O
      \t| \\|/
      \t|
      \t|
      \t|_____"
    when 3
      puts "
      \t|---
      \t|  O
      \t| \\|/
      \t| /
      \t|
      \t|_____"
    when 4
      puts "
      \t|---
      \t|  O
      \t| \\|/
      \t| /|
      \t|
      \t|_____"
    when 5
      puts "
      \t|---
      \t|
      \t|  O
      \t| \\|/
      \t| /|\\
      \t|_____"
    when 6
      puts "
      \t|---
      \t|  |
      \t|  O
      \t| \\|/
      \t| /|\\
      \t|_____"
  end
end

HangMan.new.play_game