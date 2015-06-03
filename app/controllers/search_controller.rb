class SearchController < ApplicationController
  PER_PAGE_RESULTS_LIMIT = 3
  CLASS_TO_SEARCH = {
      'All' => [User, Note],
      'Users' => [User],
      'Notes' => [Note]
  }
  SEARCH_RESULTS_PAGE_LIMIT = 5

  def sanitize_search_string(search_string)
    search_string = params[:search_string].gsub(/[^a-zA-Z0-9\-\._\s]/, "")
  end

  def search_autocomplete
    @search_string = sanitize_search_string(params[:search_string])
    search_argument = @search_string.strip.blank? ? '' : '*' + @search_string + '*'
    @users = User.search search_argument, :per_page => PER_PAGE_RESULTS_LIMIT, :ranker => :bm25
    @notes = Note.search search_argument, :per_page => PER_PAGE_RESULTS_LIMIT, :ranker => :bm25
    render :partial => 'search/search_auto_complete_html'
  end

  def detailed_search_results
    @select_filter_options = CLASS_TO_SEARCH.keys
    @default_selected_filter = @select_filter_options.first # 'ALL'
    @page_to_display = params.has_key?(:page) ? params[:page] : 1

    @search_string = sanitize_search_string(params[:search_string])
    search_argument = @search_string.strip.blank? ? '' : '*' + @search_string + '*'
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