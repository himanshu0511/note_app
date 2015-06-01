class SearchController < ApplicationController
  PER_PAGE_RESULTS_LIMIT = 3
  USERS = 1
  NOTES = 2
  ALL = 3
  CLASS_TO_SEARCH = {
      ALL => [User, Note],
      USERS => [User],
      NOTES => [Note]
  }
  CLASS_TO_SEARCH.default = CLASS_TO_SEARCH[ALL]
  SEARCH_FILTER_OPTIONS = [['All', ALL], ['Users', USERS], ['Notes', NOTES]]
  SEARCH_RESULTS_PAGE_LIMIT = 5

  def search_autocomplete
    @users = User.search params[:search_string], :per_page => PER_PAGE_RESULTS_LIMIT, :ranker => :bm25
    @notes = Note.search params[:search_string], :per_page => PER_PAGE_RESULTS_LIMIT, :ranker => :bm25
    render :partial => 'search/search_auto_complete_html'
  end

  def detailed_search_results
    @default_selected_filter = ALL
    @select_filter_options = SEARCH_FILTER_OPTIONS
    @page_to_display = params.has_key?(:page) ? params[:page] : 1
    @results = ThinkingSphinx.search(
        params[:search_string],
        :classes => CLASS_TO_SEARCH[params[:filter].to_i],
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