
<!doctype html>
<html class="no-js" lang="vi">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Datatable - View ADS</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" type="image/png" href="assets/images/icon/favicon.ico">
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/themify-icons.css">
        <link rel="stylesheet" href="assets/css/metisMenu.css">
        <link rel="stylesheet" href="assets/css/owl.carousel.min.css">
        <link rel="stylesheet" href="assets/css/slicknav.min.css">
        <!-- amcharts css -->
        <link rel="stylesheet" href="https://www.amcharts.com/lib/3/plugins/export/export.css" type="text/css" media="all" />
        <!-- Start datatable css -->
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.18/css/dataTables.bootstrap4.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.2.3/css/responsive.bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.2.3/css/responsive.jqueryui.min.css">
        <!-- style css -->
        <link rel="stylesheet" href="assets/css/typography.css">
        <link rel="stylesheet" href="assets/css/default-css.css">
        <link rel="stylesheet" href="assets/css/styles.css">
        <link rel="stylesheet" href="assets/css/responsive.css">
        <!-- modernizr css -->
        <script src="assets/js/vendor/modernizr-2.8.3.min.js"></script>
    </head>
    <style>
        *,
        *:before,
        *:after {
            box-sizing: border-box;
        }
        body {
            padding: 1em;
            font-family: "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: 15px;
            color: #b9b9b9;
            background-color: #e3e3e3;
        }
        h4 {
            color: #f0a500;
        }
        input,
        input[type="radio"] + label,
        input[type="checkbox"] + label:before,
        select option,
        select {
            width: 47%;
            padding: 1em;
            line-height: 1.4;
            background-color: #f9f9f9;
            border: 1px solid #e5e5e5;
            border-radius: 3px;
            -webkit-transition: 0.35s ease-in-out;
            -moz-transition: 0.35s ease-in-out;
            -o-transition: 0.35s ease-in-out;
            transition: 0.35s ease-in-out;
            transition: all 0.35s ease-in-out;
        }
        input:focus {
            outline: 0;
            border-color: #bd8200;
        }
        input:focus + .input-icon i {
            color: #f0a500;
        }
        input:focus + .input-icon:after {
            border-right-color: #f0a500;
        }
        input[type="radio"] {
            display: none;
        }
        input[type="radio"] + label,
        select {
            display: inline-block;
            width: 50%;
            text-align: center;
            float: left;
            border-radius: 0;
        }
        input[type="radio"] + label:first-of-type {
            border-top-left-radius: 3px;
            border-bottom-left-radius: 3px;
        }
        input[type="radio"] + label:last-of-type {
            border-top-right-radius: 3px;
            border-bottom-right-radius: 3px;
        }
        input[type="radio"] + label i {
            padding-right: 0.4em;
        }
        input[type="radio"]:checked + label,
        input:checked + label:before,
        select:focus,
        select:active {
            background-color: #f0a500;
            color: #fff;
            border-color: #bd8200;
        }
        input[type="checkbox"] {
            display: none;
        }
        input[type="checkbox"] + label {
            position: relative;
            display: block;
            padding-left: 1.6em;
        }
        input[type="checkbox"] + label:before {
            position: absolute;
            top: 0.2em;
            left: 0;
            display: block;
            width: 1em;
            height: 1em;
            padding: 0;
            content: "";
        }
        input[type="checkbox"] + label:after {
            position: absolute;
            top: 0.45em;
            left: 0.2em;
            font-size: 0.8em;
            color: #fff;
            opacity: 0;
            font-family: FontAwesome;
            content: "\f00c";
        }
        input:checked + label:after {
            opacity: 1;
        }
        select {
            height: 3.4em;
            line-height: 2;
        }
        select:first-of-type {
            border-top-left-radius: 3px;
            border-bottom-left-radius: 3px;
        }
        select:last-of-type {
            border-top-right-radius: 3px;
            border-bottom-right-radius: 3px;
        }
        select:focus,
        select:active {
            outline: 0;
        }
        select option {
            background-color: #f0a500;
            color: #fff;
        }
        .input-group {
            margin-bottom: 1em;
            zoom: 1;
        }
        .input-group:before,
        .input-group:after {
            content: "";
            display: table;
        }
        .input-group:after {
            clear: both;
        }
        .input-group-icon {
            position: relative;
        }
        .input-group-icon input {
            padding-left: 4.4em;
        }
        .input-group-icon .input-icon {
            position: absolute;
            top: 0;
            left: 0;
            width: 3.4em;
            height: 3.4em;
            line-height: 3.4em;
            text-align: center;
            pointer-events: none;
        }
        .input-group-icon .input-icon:after {
            position: absolute;
            top: 0.6em;
            bottom: 0.6em;
            left: 3.4em;
            display: block;
            border-right: 1px solid #e5e5e5;
            content: "";
            -webkit-transition: 0.35s ease-in-out;
            -moz-transition: 0.35s ease-in-out;
            -o-transition: 0.35s ease-in-out;
            transition: 0.35s ease-in-out;
            transition: all 0.35s ease-in-out;
        }
        .input-group-icon .input-icon i {
            -webkit-transition: 0.35s ease-in-out;
            -moz-transition: 0.35s ease-in-out;
            -o-transition: 0.35s ease-in-out;
            transition: 0.35s ease-in-out;
            transition: all 0.35s ease-in-out;
        }
        .container {
            max-width: 38em;
            padding: 1em 3em 2em 3em;
            margin: 0em auto;
            background-color: #fff;
            border-radius: 4.2px;
            box-shadow: 0px 3px 10px -2px rgba(0, 0, 0, 0.2);
        }
        .row {
            zoom: 1;
        }
        .row:before,
        .row:after {
            content: "";
            display: table;
        }
        .row:after {
            clear: both;
        }
        .col-half {
            padding-right: 10px;
            float: left;
            width: 50%;
        }
        .col-half:last-of-type {
            padding-right: 0;
        }
        .col-third {
            padding-right: 10px;
            float: left;
            width: 33.33333333%;
        }
        .col-third:last-of-type {
            padding-right: 0;
        }
        .product-info-container form {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .product-info-container form .input-group {
            width: 60%;
            margin-right: 10px;
        }

        .product-info-container form #smart-button-container {
            width: 30%;
            text-align: right;
        }

    </style>
    <body>

        <!--[if lt IE 8]>
                <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
            <![endif]-->
        <!-- preloader area start -->
        <div id="preloader">
            <div class="loader"></div>
        </div>
        <!-- preloader area end -->
        <!-- page container area start -->
        <div class="page-container">
            <!-- sidebar menu area start -->
            <div class="sidebar-menu">
                <div class="sidebar-header">
                    <div class="logo">
                        <a href="/SocialNetworkIRCNV/Business/BusinessIndex.jsp?BID="><img src="" alt="logo"></a>
                    </div>
                </div>
                <div class="main-menu">
                    <div class="menu-inner">
                        <nav>
                            <ul class="metismenu" id="menu">
                                <li class="active">
                                    <a href="javascript:void(0)" aria-expanded="true"><i class="ti-dashboard"></i><span>dashboard</span></a>
                                </li>
                                <li>
                                    <a href="javascript:void(0)" aria-expanded="true"><i class="ti-flag-alt"></i><span>Reported Content
                                        </span></a>
                                    <ul class="collapse">
                                        <li><a href="ViewAds.jsp?BID=">View advertise</a></li>
                                        <li><a href="AddAds.jsp?BID=">Add advertise</a></li>
                                        <li><a href="CommentsReports.jsp?BID=">Post advertise</a></li>
                                    </ul>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
            <!-- sidebar menu area end -->
            <!-- main content area start -->
            <div class="main-content">
                <!-- header area start -->
                <div class="header-area">
                    <div class="row align-items-center">
                        <!-- nav and search button -->
                        <div class="col-md-6 col-sm-8 clearfix">
                            <div class="nav-btn pull-left">
                                <span></span>
                                <span></span>
                                <span></span>
                            </div>
                            <div class="search-box pull-left">
                            </div>
                        </div>
                        <!-- profile info & task notification -->

                    </div>
                </div>
                <!-- header area end -->
                <!-- page title area start -->
                <div class="page-title-area">
                    <div class="row align-items-center">
                        <div class="col-sm-6">
                            <div class="breadcrumbs-area clearfix">
                                <h4 class="page-title pull-left">Dashboard</h4>
                                <ul class="breadcrumbs pull-left">
                                    <li><a href="/SocialNetworkIRCNV/Business/BusinessIndex.jsp?BID=">Home</a></li>
                                    <li><span>Dashboard</span></li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-sm-6 clearfix">
                            <div class="user-profile pull-right">
                                <img class="avatar user-thumb" src="" alt="avatar">
                                <h4 class="user-name dropdown-toggle" data-toggle="dropdown"><i class="fa fa-angle-down"></i></h4>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item" href="#">Update</a>
                                    <a class="dropdown-item" href="/SocialNetworkIRCNV/HomePage/HomePage.jsp">Back to home</a>
                                    <a class="dropdown-item" href="#">Delete</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- page title area end -->
                <div class="main-content-inner">
                    <!-- sales report area start -->
                    <!-- sales report area end -->
                    <!-- overview area start -->
                    <div class="row">
                        <div class="col-11 mt-5">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="header-title">List Advertise</h4>
                                    <div style="display: inline">

                                    </div>
                                    <div class="data-tables datatable-primary">

                                        <div class="input-group input-group-icon" style="margin-left: 28%;">
                                            <div class="input-icon">
                                                <i class="fa fa-user"></i> 
                                            </div>
                                            <input type="text" name="brandname" required>
                                        </div>

                                        <div class="input-group input-group-icon" style="margin-left: 28%;">
                                            <div class="input-icon">
                                                <i class="fa fa-map-marker"></i>
                                            </div>
                                            <input type="text" name="address" required>
                                        </div>

                                        <div class="input-group input-group-icon" style="margin-left: 28%;">
                                            <div class="input-icon">
                                                <i class="fa fa-envelope"></i> 
                                            </div>
                                            <input type="email" name="email" required>
                                        </div>

                                        <div class="input-group input-group-icon" style="margin-left: 28%;">
                                            <div class="input-icon">
                                                <i class="fa fa-phone"></i> 
                                            </div>
                                            <input type="text" name="phonenumber" required>
                                        </div>

                                        <div class="input-group input-group-icon" style="margin-left: 28%;">
                                            <div class="input-icon">
                                                <i class="fa fa-info-circle"></i> 
                                            </div>
                                            <input type="text" name="intro" required>
                                        </div>



                                        <!-- Add more rows as needed -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- overview area end -->
                    <!-- market value area start -->
                    <!-- market value area end -->
                    <!-- row area start -->
                    <!-- row area end -->
                    <!-- row area start-->
                </div>
            </div>
            <!-- main content area end -->
            <!-- footer area start-->
            <footer>
                <div class="footer-area">
                    <p>© Copyright 2023. All right reserved. Template by <a href="https://colorlib.com/wp/">Colorlib</a>.</p>
                </div>
            </footer>
            <!-- footer area end-->
        </div>
        <div class="modal" id = "postAdsModal" tabindex="-1" role="dialog" style="font-size: 15px;">
            <link rel="stylesheet" href="css/post.css">
            <div class="modal-dialog" role="document">
                <div class="modal-content" style="width: 700px;">
                    <div class="modal-header" style="font-size: 15px;">
                        <h5 class="modal-title">POST ADVERTISEMENT</h5>                      
                    </div>
                    <div class="modal-body">
                        <div class="post" style="margin: 10px; background: white; border-radius: 10px" id="">
                            <label style="margin-left: 2%" id="quantity"> </label>  
                            <div class="post-top">
                                <p style="display: none"></p>
                                <div class="dp" >
                                    <img src=""  style="width: 100%;" >
                                    <p id="AID-pay"></p>
                                    <p id="BID-pay"></p>
                                </div>

                                <div class="post-info">
                                    <p class="name" style="color: #003140" id="name-post-modal"></p>
                                    <p class="time" style="color: #003140">sponsored</p>
                                </div>
                            </div>
                            <div class="post-content" style="text-align: center;">
                                <p style="text-align: left; word-wrap:break-word; margin-right: 20px;" id="content-post-modal"></p>
                                <img id="image-post-modal" src=""style="margin: 0 auto; max-width: 100%"/>

                            </div>
                            <div style="margin-top:10px; display: inline" >
                                <label style="margin-left: 2%">Add more quantity: </label>
                                <input style="margin-left: 2%" id="quantity-post-modal" type="number">
                                <p style="margin-left: 2%" id="price-post-modal">Price: 0$</p>
                                <button style="margin-left: 2%" type="button" class="btn btn-primary" id="pay" onclick="pay()" >Pay</button>
                            </div>           
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" onclick="postAdsToUser()" id="post-modal" style="font-size: 15px;">Active</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="font-size: 15px;">Close</button>
                    </div>
                </div>
            </div>
            <script>

            </script>
        </div>
        <div class="modal" id = "viewAdsModal" tabindex="-1" role="dialog" style="font-size: 15px;">
            <style>
                .post-top{
                    display:flex;
                    align-items: center;
                    padding:10px;
                    padding-bottom: 0;
                }

                .post-top .dp{
                    width:60px;
                    height:60px;
                    border-radius: 50%;
                    overflow:hidden;
                }

                .post-top .dp > img{

                    cursor:pointer;
                }

                .post-top .post-info{
                    margin-left:10px;
                    font-weight: bold;
                }

                .post-top .post-info .name{
                    cursor:pointer;
                    font-size:23px;
                    margin-bottom: 0;
                }

                .post-top .post-info .time{
                    font-size:14px;
                    cursor:pointer;
                }
            </style>
            <div class="modal-dialog" role="document">
                <div class="modal-content" style="width: 700px;">
                    <div class="modal-header" style="font-size: 15px;">
                        <h5 class="modal-title">Edit Post</h5>                      
                    </div>
                    <div class="modal-body">

                        <div class="post-top">
                            <p style="display: none" id="IDpost"></p>
                            <div class="dp" >
                                <img id="imgUser" src="" alt="" style="width: 100%;" >
                            </div>
                            <div class="post-info">
                                <p class="name" style="color: #003140" id="FullNameU"></p>
                            </div>
                        </div>
                        <div class="post-content" style="text-align: center;">
                            <textarea rows ="2" style="width: 100%; border: none;" id="contentPost"></textarea>
                            <img id="imgPost" src="" style=" max-width: 660px; max-height: 660px;"/>
                            <br>
                            <input type="file" accept="image,gif/*,capture=camera" name="photoPost" id="fileInput2" />
                            <button class="btn btn-primary" style="font-size: 15px;" type="button" onclick="clearFileInput()">Clear File Input</button>
                        </div>
                    </div>
                    <div style="margin-top:10px; ">
                        <label style="margin-left: 2%" id="num-quantity"> </label>

                    </div>
                    <div class="modal-footer">
                        <button id="save-change" type="submit" class="btn btn-primary" style="font-size: 15px;" onclick="saveChange()">Save changes</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="font-size: 15px;">Close</button>

                    </div>
                </div>
            </div>
            <script>

                document.getElementById('fileInput2').addEventListener('change', function (event) {
                    var file = event.target.files[0];

                    // T?o ??i t??ng FileReader ?? ??c t?p tin
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var previewImage = document.getElementById('imgPost');
                        previewImage.src = e.target.result;
                        previewImage.style = " max-width:660px; max-height:660px;";
                    };
                    reader.readAsDataURL(file);
                });
            </script>
        </div>
        <!-- page container area end -->
        <!-- offset area start -->
        <!-- offset area end -->
        <!-- jquery latest version -->
        <script src="assets/js/vendor/jquery-2.2.4.min.js"></script>
        <!-- bootstrap 4 js -->
        <script src="assets/js/vendor/jquery-2.2.4.min.js"></script>
        <!-- bootstrap 4 js -->
        <script src="assets/js/popper.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/owl.carousel.min.js"></script>
        <script src="assets/js/metisMenu.min.js"></script>
        <script src="assets/js/jquery.slimscroll.min.js"></script>
        <script src="assets/js/jquery.slicknav.min.js"></script>

        <!-- Start datatable js -->
        <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
        <script src="https://cdn.datatables.net/1.10.18/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.18/js/dataTables.bootstrap4.min.js"></script>
        <script src="https://cdn.datatables.net/responsive/2.2.3/js/dataTables.responsive.min.js"></script>
        <script src="https://cdn.datatables.net/responsive/2.2.3/js/responsive.bootstrap.min.js"></script>
        <!-- others plugins -->
        <script src="assets/js/plugins.js"></script>
        <script src="assets/js/scripts.js"></script>
        <script src="js/viewads.js"></script>
        <script src="/SocialNetworkIRCNV/js/forAll.js" ></script>
    </body>

</html>
