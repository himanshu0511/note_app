class SearchController < ApplicationController
  before_filter :authenticate_user!

  PER_PAGE_RESULTS_LIMIT = 3
  CLASS_TO_SEARCH = {
      'All' => [User, Note],
      'Users' => [User],
      'Notes' => [Note]
  }
  SEARCH_RESULTS_PAGE_LIMIT = 6
  TRUNCATE_TO_SMALL_LENGTH = 25
  TRUNCATE_TO_LENGTH = 200

  def sanitize_search_string(search_string)
    search_string = params[:search_string].gsub(/[^a-zA-Z0-9\-\._\s]/, "")
  end

  def generate_search_argument(search_string)
    search_argument = ''
    string_array = search_string.split(' ')
    string_array.each_with_index do |search_word, index|
      search_argument += '*' + search_word + '*'
      if index !=  string_array.length - 1
        search_argument += '|'
      end
    end
    search_argument
  end

  def search_autocomplete
    @search_string = sanitize_search_string(params[:search_string])
    @truncate_to_length = TRUNCATE_TO_SMALL_LENGTH
    search_argument = generate_search_argument(@search_string)
    @users = User.search search_argument, :per_page => PER_PAGE_RESULTS_LIMIT, :ranker => :bm25
    @notes = Note.search search_argument, :per_page => PER_PAGE_RESULTS_LIMIT, :ranker => :bm25
    render :partial => 'search/search_auto_complete_html'
  end

  def detailed_search_results
    @select_filter_options = CLASS_TO_SEARCH.keys
    @default_selected_filter = @select_filter_options.first # 'ALL'
    @page_to_display = params.has_key?(:page) ? params[:page] : 1
    @truncate_to_length = TRUNCATE_TO_LENGTH


    @search_string = sanitize_search_string(params[:search_string])
    search_argument = generate_search_argument(@search_string)
    filter = params.has_key?(:filter) ? params[:filter] : @default_selected_filter
    @results = ThinkingSphinx.search(
        search_argument,
        :classes => CLASS_TO_SEARCH[filter],
        :ranker => :bm25,
        :per_page => SEARCH_RESULTS_PAGE_LIMIT,
        :page => @page_to_display
    )
    if request.xhr?
      render :partial => 'search/search_results'
    else
      render 'search/search_results'
    end
  end
end