function relate(Type, UID) {
    var isfriend = "<div style='color: blue'><i class='fa-solid fa-user-check'></i> Your Friend </div>";
    var request = "<div style='color: black'><i class='fa-solid fa-people-arrows'></i> Requested </div>";
    var isNotFriend = "<div style='color: black'><i class='fa-solid fa-user-check'></i> Stranger </div>";
    var friendstatus = document.getElementById('friendstatus');
    $.ajax({
        url: "/SocialNetworkIRCNV/Relation",
        type: "POST",
        data: {Type: Type, UID: UID},
        success: function (data) {
            if (data === "null") {
                alert('Request Fail');
            } else {
                friendstatus.innerHTML = data;
            }

        },
        error: function (xhr) {
            console.log("?ã x?y ra l?i: ");
        }
    });
}

document.addEventListener('DOMContentLoaded', function () {
    var offsett = document.getElementById('offset');
    var post = document.getElementById('post');
    var btnloadmore = document.getElementById('btnloadmore');
    $.ajax({
        url: "/SocialNetworkIRCNV/GetLoadPost",
        type: "POST",
        data: {type: 'profileinfo', UID: 'UID.innerHTML', offset: '1'},
        success: function (data) {
            if (data === "null") {
                btnloadmore.innerHTML = 'You didnt have any post: ';
            } else {
                var currentOffset = parseInt(offsett.innerHTML);
                offsett.innerHTML = currentOffset + 1;
                post.innerHTML = post.innerHTML + data;
            }

//            var currentOffset = parseInt(offsett.innerHTML);
//            offsett.innerHTML = currentOffset + 1;
//            post.innerHTML = currentOffset+1;
        },
        error: function (xhr) {
            console.log("?ã x?y ra l?i: ");
        }
    });
});

function changePass() {
    $('#changepass').modal('show');
}
function doChangePass() {
    var oldPass = document.getElementById('pass').value;
    var newPass = document.getElementById('newpass').value;
    var repeat = document.getElementById('repeat').value;
    if ((oldPass.trim() === '') || (newPass.trim() === '') || (repeat.trim() === '')) {
        alert('All input must be fill');
        return;
    }
    if (!(newPass.trim() === repeat.trim())) {
        alert('New pass and repeat password must be the same!!!');
        return;
    }

    $.ajax({
        url: "/SocialNetworkIRCNV/ChangePassword",
        type: "POST",
        data: {oldPass: oldPass, newPass: newPass},
        success: function (data) {
            if (data.trim() === 'true') {
                alert('!!!change password successfull!!!');
            } else {
                alert('!!!change password fail!!!');
            }
        },
        error: function (xhr) {
            console.log("?ã x?y ra l?i: ");
        }
    });
}