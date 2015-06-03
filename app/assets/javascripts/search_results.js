// execute js for specific page only
SearchResultsModule = function () {
    var thisInstance = this;
    //page_constants
    thisInstance.constants = {
        selectors: {
            search_filter_selector: '.js_search_filter a',
            search_results_container_selector: '.js_results_container'
        }
    };
    // function to fetch search filtered list
    function fetch_filtered_results_and_populate(options) {// private function
        if (!fetch_filtered_results_and_populate.ajaxLock) {
            fetch_filtered_results_and_populate.ajaxLock = true;
            $.ajax({
                url: options.url,
                method: 'get',
                data: {filter: options.searchFilter},
                dataType: 'html'
            }).done(function (searchResultsHtml) {
                options.$searchResultContainer.html(searchResultsHtml);
                options.callback();
            }).always(function () {
                fetch_filtered_results_and_populate.ajaxLock = false
            });
        }
    }

    // tasks and bindings on page initialization
    thisInstance.init = function (page) {page = page || {};
        page = $.extend(true, page || {}, {constants: {selectors: {}, urls: {}}});
        thisInstance.constants = $.extend(true, thisInstance.constants, page.constants);
        var selectors = thisInstance.constants.selectors,
            $searchFilter = $(selectors.search_filter_selector);
        thisInstance.constants.urls.search_filter_url = $searchFilter.data('url');
        //fetch filter search results according to filter selected
        var $searchResultsContainer = $(selectors.search_results_container_selector);
        $searchFilter.on('click', function () {
            var $this = $(this),
                filterValue = $this.data('value');
            fetch_filtered_results_and_populate({
                searchFilter: filterValue,
                $searchResultContainer: $searchResultsContainer,
                url: thisInstance.constants.urls.search_filter_url,
                callback: function(){
                    $searchFilter.removeClass('selected');
                    $this.addClass('selected');
                }
            });
        });
    };
};