class HangMan

  MAX_NUMBER_OF_GUESSES = 6

  def initialize(user_input = UserInput.new, word_to_guess = choose_random_word)
    @word_to_guess = word_to_guess
    @user_input = user_input
    @number_of_wrong_guesses = 0
    @dash_array = init_dash_array
    @array_picture = [  "\t|---\n\t|  O\n\t|  |\n\t|  \n\t|_____" ]
    @already_guessed_letter = Array.new
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
    puts "Try again (y/n)? "
    try_again = (gets.chomp).downcase
    puts "#{(try_again == "y")? HangMan.new.play_game : "Bye.."}"
  end

  def game_round
    puts "#{@dash_array.join ' '}"
    guess = @user_input.get_input

    if (@already_guessed_letter.include? guess)
      puts "You already guessed this letter. Give another letter."

    elsif @word_to_guess.include?(guess)
      @already_guessed_letter << guess
      (0 .. @word_to_guess.length - 1).each do |i|
        position = @word_to_guess.index(guess, i)
        if position != nil
          @dash_array[position] = guess
        end
      end

    else
      @number_of_wrong_guesses += 1
      puts "wrongGuess count = #{@number_of_wrong_guesses}"
      @already_guessed_letter << guess
      hangman_picture
    end
  end
end

class UserInput
  def get_input
    puts 'guess a letter'
    input = (gets.chomp).downcase
    if (input =~ /^[a-zA-Z]$/)
      input
    else
      puts "This is not a valid letter."
      get_input
    end
  end
end

def hangman_picture
  case @number_of_wrong_guesses
    when 1
      puts "\n #{@array_picture[0]="\t|---\n\t|  O\n\t|  |/\n\t|  \n\t|_____"}"
    when 2
      puts "\n #{@array_picture[0]="\t|---\n\t|  O\n\t| \\|/\n\t|  \n\t|_____"}"
    when 3
      puts "\n #{@array_picture[0]="\t|---\n\t|  O\n\t| \\|/\n\t| /\n\t|_____"}"
    when 4
      puts "\n #{@array_picture[0]="\t|---\n\t|  O\n\t| \\|/\n\t| /|\n\t|_____"}"
    when 5
      puts "\n #{@array_picture[0]="\t|---\n\t|  O\n\t| \\|/\n\t| /|\\\n\t|_____"}"
    when 6
      puts "\n #{@array_picture[0]="\t|---\n\t|  |\n\t|  O\n\t| \\|/\n\t| /|\\\n\t|_____"}"
  end
end

HangMan.new.play_game