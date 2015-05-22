// execute js on page load
$(document).on('pageload ready',function(){
    // execute js for specific page only
    (function (page, undefined) {
        if (page.name == 'note') {

            //fetch notes from server and populate list of notes for appropriate filter selected
            $('#filter_selected').change(function(){
                $ajax({
                    url: page.constants.fetch_list_of_notes_url,
                    method: 'get',
                    data: data,
                    dataType: 'json',
                    contentType: 'application/json'
                }).done(function(data){

                });
            });
        }
    })(page);
});