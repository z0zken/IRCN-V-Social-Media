

function updateInfor(BID) {
    //name address email phone intro
    if (!confirm("Are you sure to update this infomation"))
        return;
    var name = document.getElementById('name').value;
    var address = document.getElementById('address').value;
    var email = document.getElementById('email').value;
    var phone = document.getElementById('phone').value;
    var intro = document.getElementById('intro').value;
    $.ajax({
        url: "/SocialNetworkIRCNV/UpdateBusiness",
        type: "POST",
        data: {BID: BID, name: name, address: address, email: email, phone: phone, intro: intro},
        success: function (data) {
            if (data.trim() === 'null')
                alert("!!!Update information fail!!!");
            else
                alert("!!!Update information successfull!!!");
        },
        error: function (xhr) {
            console.log("?? x?y ra l?i: ");
            alert("Something wrong happen" + xhr);
        }
    });
}

