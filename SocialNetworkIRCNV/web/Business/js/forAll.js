/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */



function deleteBusiness(BID) {
    if (!confirm("!!Are you sure to delete this business!!!"))
        return;
    $.ajax({
        url: "/SocialNetworkIRCNV/DeleteBusniness",
        type: "POST",
        data: {type: 'BID', BID: BID},
        success: function (data) {
            if (data.trim() === 'null')
                alert("!!!Delete business fail!!!");
            else if (confirm("!!!Delete business successfull!!!")) {
                window.location.href = "/SocialNetworkIRCNV/Authen/login.jsp";
                //window.location.assign("/SocialNetworkIRCNV/Authen/login.jsp");
                //window.location.replace("/SocialNetworkIRCNV/Authen/login.jsp");
            } else {
                window.location.href = "/SocialNetworkIRCNV/Authen/login.jsp";
                //window.location.assign("/SocialNetworkIRCNV/Authen/login.jsp");
                //window.location.replace("/SocialNetworkIRCNV/Authen/login.jsp");
            }
        },
        error: function (xhr) {
            console.log("?? x?y ra l?i: ");
            alert("Something wrong happen" + xhr);
        }
    });
}