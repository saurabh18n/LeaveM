

var dateformar = 'dd-mm-yyyy';

$(function () {
});

function pageLoad() {
    $('#text_SearchTerm').attr("placeholder", "Name or WIN");
       
} 

function updateTakenDays() {
    var dateto = new Date(text_taken_dateto.value);
    var datefrom = new Date(text_taken_datefrom.value);
    $('#text_taken_days').val(((dateto - datefrom)/(1000 * 3600 * 24))+1)
}


function checkTearchTerm() {
    if ($('#text_SearchTerm').val().length < 3) {
        alert('Search Term must be more then 3 Charector')
        return false;
    } else {
        return true;
    }
}

function validate_Accumulate() {
    if ($('#text_accumulate_add_date').val() == '' || $('#text_accumulate_add_days') == '') {
        alert('Please Fill All Fields')
        return false;
    } else {
        return true;
    }
}

function validate_taken() {
    if (text_taken_datefrom.value == '' || text_taken_dateto.value == '' || text_taken_days.value == '') {
        alert('Please compkete required fields');
        return false;
    } else {
        return true;
    }
    
    
    
}

function validateAddemployee(e) {
    let addform = document.getElementById["adminForm"];
    if (addform.checkValidity()) {
        return true;
    } else {
        return false;
    }
}
function genrateUdername() {

    text_addemp_uname.value = text_addemp_fname.value + text_addemp_lname.value
}

