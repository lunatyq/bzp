class TextAnalysis
  class TextAnalysisMatch < TextAnalysis
    attr_accessor :marker_id

    def initialize(text, marker_id)
      super(text)
      @marker_id = marker_id
    end
  end


  UnprettyToPretty = {
                     "Ã" => "A", "Ą" => "A", "À" => "A", "Å" => "A", "Ä" => "A", "Á" => "A", "Â" => "A", "Æ" => "AE",
                     "Ć" => "C", "Ç" => "C", "Ð" => "DH", "È" => "E", "Ë" => "E", "Ê" => "E", "Ę" => "E", "É" => "E",
                     "Î" => "I", "Í" => "I", "Ì" => "I", "Ï" => "I", "Ł" => "L", "Ń" => "N", "Ñ" => "N", "Ô" => "O",
                     "Ö" => "O", "Ø" => "O", "Ó" => "O", "Õ" => "O", "Ò" => "O", "Œ" => "OE", "Ś" => "S", "Š" => "S",
                     "Þ" => "TH", "Ü" => "U", "Ù" => "U", "Ú" => "U", "Û" => "U", "Ý" => "Y", "Ÿ" => "Y", "Ż" => "Z",
                     "Ž" => "Z", "Ź" => "Z", "â" => "a", "ä" => "a", "à" => "a", "á" => "a", "å" => "a", "ą" => "a",
                     "ã" => "a", "æ" => "ae", "ć" => "c", "ç" => "c", "ð" => "dh", "è" => "e", "ë" => "e", "ę" => "e",
                     "é" => "e", "ê" => "e", "î" => "i", "ï" => "i", "í" => "i", "ì" => "i", "ł" => "l", "ñ" => "n",
                     "ń" => "n", "ó" => "o", "ò" => "o", "ô" => "o", "õ" => "o", "ø" => "o", "ö" => "o", "œ" => "oe",
                     "š" => "s", "ś" => "s", "ß" => "ss", "þ" => "th", "µ" => "u", "ù" => "u", "û" => "u", "ú" => "u",
                     "ü" => "u", "ÿ" => "y", "ý" => "y", "ž" => "z", "ź" => "z", "ż" => "z"
  }

  UnprettyChars    = UnprettyToPretty.keys.join

  Numbers          = "0-9"
  PrettyLetters    = "A-Za-z"
  PrettyChars      = "#{PrettyLetters}#{Numbers}"

  RealWordsSplitPatternWithParagraphAndPercent = /([#{PrettyLetters}#{UnprettyChars}]+|[#{Numbers}]+)|([^#{PrettyLetters}#{Numbers}#{UnprettyChars}§%]+)|([§%])/

  attr_reader :text, :path

  def initialize(text,path=nil)
    @text = self.class.normalize_text(text.to_s)
    @path = path
  end


  def real_words
    @real_words ||= unserialize(:real_words) || @text.scan(/([#{PrettyLetters}#{UnprettyChars}]+|[#{Numbers}]+)|([^#{PrettyLetters}#{Numbers}#{UnprettyChars}]+)/).inject([]) { |memo, word_and_non_word| memo << [nil, ""] if memo.last && memo.last.first && word_and_non_word.first; memo << word_and_non_word }.collect { |w| w.first || w.last }
    #PARAGRAPH AND PERCENT ## @real_words ||= unserialize(:real_words) || @text.scan(RealWordsPattern).inject([]) do |memo, word_and_non_word|
    #PARAGRAPH AND PERCENT ##   memo << [nil, "", nil] if memo.last && memo.last.first && word_and_non_word.first # memo.last - was somethimg, memo.last.first was a letter and it is a number or reverse
    #PARAGRAPH AND PERCENT ##
    #PARAGRAPH AND PERCENT ##   if memo.last && memo.last.last && word_and_non_word.first
    #PARAGRAPH AND PERCENT ##     memo << [nil, "", nil]
    #PARAGRAPH AND PERCENT ##   end
    #PARAGRAPH AND PERCENT ##
    #PARAGRAPH AND PERCENT ##   if word_and_non_word.last
    #PARAGRAPH AND PERCENT ##     if memo.last && memo.last.first # if there was some text or number insert a separator
    #PARAGRAPH AND PERCENT ##       memo << [nil, "", nil]
    #PARAGRAPH AND PERCENT ##     end
    #PARAGRAPH AND PERCENT ##   end
    #PARAGRAPH AND PERCENT ##
    #PARAGRAPH AND PERCENT ##   memo << word_and_non_word
    #PARAGRAPH AND PERCENT ##
    #PARAGRAPH AND PERCENT ##   #if # append nil, "" when  matched % or § needed when previous was a character
    #PARAGRAPH AND PERCENT ##   #  memo[-1..-1] = [[nil, ""], memo[-1], [nil, ""]]
    #PARAGRAPH AND PERCENT ##   #end
    #PARAGRAPH AND PERCENT ##
    #PARAGRAPH AND PERCENT ## end.collect { |w| w.compact.first }
  end

  def html_safe_words
    @html_safe_words ||= begin
      pattern = /[#{ERB::Util::HTML_ESCAPE.keys.join}]/
      real_words.map { |rw| rw.gsub(pattern) { |w| ERB::Util::HTML_ESCAPE[w] } }
    end
  end

  def clean_downcased_text
    @clean_downcased_text ||= UnprettyToPretty.inject(@text) { |memo, args| memo.gsub(*args) }.downcase
  end

  def replace(replacements,with=:clean_words)
    replaced = []
    words    = send(with)
    words.each_with_index do |cw, idx|
      replacement   = cw && replacements[cw]
      replaced[idx] = replacement || real_words[idx]
    end

    replaced.join
  end

  def kinds
    @kinds ||= begin
     kinds = []
     real_words.each_with_index do |word, index|
       kind   = :blank if word.blank?
       kind ||= case clean_words[index]
         when /[0-9]/ then :number
         when /[a-z]/ then :letters
       else
         :glue
       end

       kinds << kind
     end

     kinds
    end
  end

  def joined_words
    @joined_words ||= begin
      words          = []
      current_word   = []

      kinds.each_with_index do |kind, index|
        if kind == :blank
            if kinds[index-1] == :letters && kinds[index+1] == :number or
               kinds[index-1] == :number && kinds[index+1] == :letters
               current_word << index
            else
              words << current_word if current_word.size > 1
              current_word = []
            end
         else
           current_word << index
         end
      end

      words << current_word if current_word.size > 1

      words
    end
  end

  def size
    clean_words_strip.size
  end

  def clean_words
    @clean_words ||= unserialize(:clean_words) || clean_downcased_text.
    #sub(/^§/,'paragraf ').sub(/§$/,' paragraf').gsub(/([§])/, ' paragraf ').sub(/^%/, 'procent ').sub(/%$/, ' procent').gsub(/([%])/, ' procent ').
    scan(/([a-z]+|[0-9]+)|([^a-z0-9]+)/).inject([]) { |memo, word_and_non_word| memo << [nil, ""] if memo.last && memo.last.first && word_and_non_word.first; memo << word_and_non_word }.collect { |w| w.first }
  end

  def clean_words_index
    @clean_words_index ||= unserialize(:clean_words_index) || create_index(:clean_words)
  end

  def clean_words_stem_index
    @clean_words_stem_index ||= unserialize(:clean_words_stem_index) || create_index(:clean_words_stem)
  end


  def unserialize(name)
    return unless path
    full_path = path + "_#{name}"
    Marshal.load(File.read(full_path)) if File.exists?(full_path)
  end

  def serialize
    return unless path
    %w(clean_words clean_words_strip html_safe_words clean_words_index real_words clean_words_stem clean_words_stem_index).each do |name|
      value = send(name)
      File.open(path + "_#{name}","w") { |f| f.syswrite Marshal.dump(value) }
    end

    File.open(path, "w") { |f| f.syswrite Marshal.dump(self) }
  end

  def create_index(name)
    cw = {}

    send(name).each_with_index do |word, index|
      cw[word] ||= []
      cw[word] << index
    end

    cw
  end

  def clean_words_strip
    @clean_words_strip ||= unserialize(:clean_words_strip) || begin
      cw = clean_words.dup
      cw[0..0]   = [] while cw.size > 0 && cw[0].nil?
      cw[-1..-1] = [] while cw.size > 0 && cw[-1].nil?
      cw
    end
  end

  def clean_words_stem
    @clean_words_stem ||= unserialize(:clean_words_stem) || clean_words.map { |w| self.class.first_form(w) }
  end

  def clean_words_stem_strip
    @clean_words_stem_strip ||= unserialize(:clean_words_stem_strip) || begin
      cw = clean_words_stem.dup
      cw[0..0]   = [] while cw[0].nil?
      cw[-1..-1] = [] while cw[-1].nil?
      cw
    end
  end

  def match(fraza,use_stem=true)
    marker_idx  = 0

    strip_words_method = use_stem ? :clean_words_stem_strip : :clean_words_strip
    words_method       = use_stem ? :clean_words_stem       : :clean_words
    words_index_method = use_stem ? :clean_words_stem_index : :clean_words_index

    sentences   = fraza.split(" ").map { |w| marker_idx +=1; sw = TextAnalysisMatch.new(w, marker_idx) }.group_by { |w| w.send(strip_words_method).first }
    sentences.each { |key, value| sentences[key] = value.partition { |f| f.send(strip_words_method).size == 1 } }

    sentence_starts = {}
    matches         = {}

    all_words_index = send(words_index_method)
    all_words       = send(words_method)

    sentences.each do |first_word, (single, multi)|
      indexes = all_words_index[first_word]

      if indexes
        indexes.each { |idx| matches[idx]         = single } unless single.empty?
        indexes.each { |idx| sentence_starts[idx] = multi  } unless multi.empty?
      end
    end

    sentence_starts.each do |index, sentences|
      found = sentences.select { |sentence| all_words[index..index+sentence.send(strip_words_method).size-1] == sentence.send(strip_words_method) }
      matches[index] = found + (matches[index] || []) unless found.empty?
    end

    matches
  end

  def find_split_words(replacements)
    all = clean_words.map { |w| DictionaryForm.new(w).forms.size rescue nil }


    all.each_with_index do |count, index|
      next if !count || count > 1

      index.downto([index-2,0].max) do |start_index|
        index.upto([index+2, all.size-1].min) do |stop_index|

          clean_word     = clean_words[start_index..stop_index].join
          new_clean_word = clean_word.gsub(/\s+/,'')

          new_word_stems = DictionaryForm.new(new_clean_word).forms
          if new_word_stems && new_word_stems.size  > 1
            real_word = real_words[start_index..stop_index].join.strip

            new_word = real_word.gsub(/[-\s]/,'')
            next if replacements.has_key?(real_word)

            puts "> #{real_words.join}"
            puts "> #{real_word} => #{new_word}"

            if gets.to_i == 0
              replacements[real_word] = false
            else
              replacements[real_word] = new_word
            end
          end
        end
      end
    end

    nil
  end

  def self.clean_downcased_text(source_text)
    new(source_text).clean_downcased_text
  end

  def self.normalize_text(source_text)
    source_text.
    gsub(/[„”]/,'"').
    gsub(/\342\200\221|\342\200\223|\357\200\255/,'-').
    gsub(/\302\240/,' ').
    gsub(/\342\200\250/,"\n").
    gsub(/\37/, "\n").
    gsub("\302\275", "1/2")
  end

  def self.first_form(word)
    (word.blank? || word.match(/^[0-9]+$/)) ? word : DictionaryForm.new(word).first_form
  end

  def self.reduce_form(phrase, which=:real_words)
    analysis      = new(phrase)
    replacements  = analysis.real_words.compact.inject({}) { |memo, w| memo.update(w => first_form(w)) }
    analysis.replace(replacements, :real_words) # Preserve query
  end
end
