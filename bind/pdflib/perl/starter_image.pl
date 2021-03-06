#!/usr/bin/perl
# $Id: starter_image.pl,v 1.1.2.3 2008/12/25 13:28:41 rp Exp $
# Starter image:
# Load and place an image using various options for scaling and positioning
#
# Place the image it its original size.
# Place the image with scaling and orientation to the west.
# Fit the image into a box with clipping.
# Fit the image into a box with proportional resizing.
# Fit the image into a box entirely.
#
# Required software: PDFlib Lite/PDFlib/PDFlib+PDI/PPS 7
# Required data: image file

use pdflib_pl 7.0;
use strict;

# This is where the data files are. Adjust as necessary.
my $searchpath = "../data";
my $outfile = "starter_image.pdf";
my $title = "Starter Image";

# create a new PDFlib object
my $p = PDF_new();

my $buf;
my $imagefile = "lionel.jpg";
my ($font, $image);
my $bw = 400;
my $bh = 200;
my $x = 20;
my $y = 580;
my $yoffset = 260;

eval {
    PDF_set_parameter($p, "SearchPath", $searchpath);

    # This means we must check return values of load_font() etc.
    PDF_set_parameter($p, "errorpolicy", "return");

    if (PDF_begin_document($p, $outfile, "") == -1) {
	printf("Error: %s\n", PDF_get_errmsg($p));
	PDF_delete($p);
	exit(2);
    }

    PDF_set_info($p, "Creator", "PDFlib Cookbook");
    $buf = $title .  '  $Revision: 1.1.2.3 $';
    PDF_set_info($p, "Title", $buf);

    # For PDFlib Lite: change "unicode" to "winansi"
    $font = PDF_load_font($p, "Helvetica", "winansi", "");
    if ($font == -1) {
	printf("Error: %s\n", PDF_get_errmsg($p));
	PDF_delete($p);
	exit(2);
    }

    # Load the image
    $image = PDF_load_image($p, "auto", $imagefile, "");
    if ($image == -1) {
	printf("Error: %s\n", PDF_get_errmsg($p));
	PDF_delete($p);
	exit(2);
    }

    # Start page 1
    PDF_begin_page_ext($p, 0, 0, "width=a4.width height=a4.height");
    PDF_setfont($p, $font, 12);


    # ------------------------------------
    # Place the image in its original size
    # ------------------------------------
    

    # Position the image in its original size with its lower left corner
    # at the reference point (20, 380)
    
    PDF_fit_image($p, $image, 20, 380, "");

    # Output some descriptive text
    PDF_fit_textline($p,
	"The image is placed with the lower left corner in its original " .
	"size at reference point (20, 380):", 20, 820, "");
    PDF_fit_textline($p, "fit_image(image, 20, 380, \"\");", 20, 800, "");


    # --------------------------------------------------------
    # Place the image with scaling and orientation to the west
    # --------------------------------------------------------
    

    # Position the image with its lower right corner at the reference
    # point (580, 20).
    # "scale=0.5" scales the image by 0.5.
    # "orientate=west" orientates the image to the west.
    
    PDF_fit_image($p, $image, 580, 20,
	"scale=0.5 position={right bottom} orientate=west");

    # Output some descriptive text
    PDF_fit_textline($p,
	"The image is placed with a scaling of 0.5 and an orientation to " .
	"the west with the lower right corner", 580, 320,
	"position={right bottom}");
    PDF_fit_textline($p,
	" at reference point (580, 20): fit_image(image, 580, 20, " .
	"\"scale=0.5 orientate=west position={right bottom}\");",
	580, 300, "position={right bottom}");

    PDF_end_page_ext($p, "");

    # Start page 2
    PDF_begin_page_ext($p, 0, 0, "width=a4.width height=a4.height");
    PDF_setfont($p, $font, 12);


    # --------------------------------------
    # Fit the image into a box with clipping
    # --------------------------------------
    

    # The "boxsize" option defines a box with a given width and height and
    # its lower left corner located at the reference point.
    # "position={right top}" positions the image on the top right of the
    # box.
    # "fitmethod=clip" clips the image to fit it into the box.
    
    $buf = "boxsize={" . $bw . " " . $bh . 
	    "} position={right top} fitmethod=clip";
    PDF_fit_image($p, $image, $x, $y, $buf);

    # Output some descriptive text
    PDF_fit_textline($p,
	"fit_image(image, x, y, \"boxsize={400 200} position={right top} " .
	"fitmethod=clip\");", 20, $y+$bh+10, "");


    # ---------------------------------------------------
    # Fit the image into a box with proportional resizing
    # ---------------------------------------------------
    

    # The "boxsize" option defines a box with a given width and height and
    # its lower left corner located at the reference point.
    # "position={center}" positions the image in the center of the
    # box.
    # "fitmethod=meet" resizes the image proportionally until its height
    # or width completely fits into the box.
    # The "showborder" option is used to illustrate the borders of the box.
    
    $buf = "boxsize={" . $bw . " " . $bh . 
		"} position={center} fitmethod=meet showborder";
    PDF_fit_image($p, $image, $x, $y-=$yoffset, $buf);

    # Output some descriptive text
    PDF_fit_textline($p,
	"fit_image(image, x, y, \"boxsize={400 200} position={center} " .
	"fitmethod=meet showborder\");", 20, $y+$bh+10, "");


    # ---------------------------------
    # Fit the image into a box entirely
    # ---------------------------------
    

    # The "boxsize" option defines a box with a given width and height and
    # its lower left corner located at the reference point.
    # By default, the image is positioned in the lower left corner of the
    # box.
    # "fitmethod=entire" resizes the image proportionally until its height
    # or width completely fits into the box.
    
    $buf =  "boxsize={" . $bw . " " . $bh . "} fitmethod=entire";
    PDF_fit_image($p, $image, $x, $y-=$yoffset, $buf);

    # Output some descriptive text
    PDF_fit_textline($p,
	"fit_image(image, x, y, \"boxsize={400 200} fitmethod=entire\");",
	20, $y+$bh+10, "");

    PDF_end_page_ext($p, "");

    PDF_close_image($p, $image);

    PDF_end_document($p, "");

};

if ($@) {
    printf("starter_image: PDFlib Exception occurred:\n");
    printf(" $@\n");
    exit;
}
