<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsi xs xlink">

	<xsl:output method="html" indent="no" encoding="utf-8"/>

	<xsl:template match="@* | node(  )">
		<xsl:copy>
			<xsl:apply-templates select="@* | node(  )"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="//abstract">
		<div>
			<xsl:choose>
				<xsl:when test="./title">
					<xsl:attribute name="id">
						<xsl:value-of select="translate(translate(./title, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), ' ', '-')" />
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="id">
						<xsl:value-of select="name(.)" />
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates />
		</div>
	</xsl:template>
	<xsl:template match="abstract/title">
		<h2><xsl:apply-templates /></h2>
	</xsl:template>


  <!-- Start transforming sections to heading levels -->
  <!-- No need to proceed sec-type="additional-information"-->
  <xsl:template match="sec[@sec-type='additional-information']"/>
  
  <xsl:template match="sec[not(@sec-type='additional-information')]">
  	<div>
      <xsl:if test="@sec-type">
        <xsl:attribute name="class">
          <xsl:value-of select="concat('section ', ./@sec-type)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*[name()!='sec-type'] | node( )" />
	</div>
  </xsl:template>
  	
  <xsl:template match="sec/title">
    <xsl:element name ="h{count(ancestor::sec) + 1}">
      <xsl:apply-templates select="@* | node( )" />
    </xsl:element>
  </xsl:template>
  <!-- END transforming sections to heading levels -->

	<xsl:template match="p">
		<p>
			<xsl:attribute name="id">
				<xsl:value-of select="concat('p-', count(preceding::p)+1)" />
			</xsl:attribute>
			<xsl:if test="ancestor::caption and (count(preceding-sibling::p) = 0)">
				<xsl:attribute name="class">
					<xsl:value-of select="'first-child'" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</p>
	</xsl:template>
	<xsl:template match="ext-link">
		<a href="{.}">
			<xsl:apply-templates />
		</a>
	</xsl:template>
	<!-- START handling citation objects -->
	<xsl:template match="xref">
		<!--
		<a id="xref-ref-19-1" class="xref-bibr" href="#ref-19" rel="#ref-19">
			Ranade et al., 2014
		</a>
		<a id="xref-ref-19-2" class="xref-bibr" href="#ref-19" rel="#ref-19">
			Ranade et al., 2014
		</a>
		<a id="xref-ref-3-1" class="xref-bibr" 
			href="#ref-3" rel="#ref-3" 
			title="">Ataga et al., 2008</a>
		<xref ref-type="bibr" rid="bib5">Chien, 1987</xref>
		-->
		<a>
			<xsl:attribute name="id">
				<xsl:variable name="rid" select="./@rid" />
				<xsl:variable name="crid" select="count(preceding::xref[@rid=$rid])+1" />
				<xsl:value-of select="concat('xref-', ./@rid, '-', $crid)" />
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('xref-', ./@ref-type)" />
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="concat('#', ./@rid)" />
			</xsl:attribute>
			<xsl:attribute name="rel">
				<xsl:value-of select="concat('#', ./@rid)" />
			</xsl:attribute>
			<xsl:apply-templates />
		</a>
	</xsl:template>
	<!-- END handling citation objects -->

	<!-- START Table Handling -->
	<xsl:template match="table-wrap">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="table-wrap/label" />
	<xsl:template match="table-wrap/label" mode="captionLabel">
		<span class="table-label">
			<xsl:apply-templates />
		</span>
	</xsl:template>
	<xsl:template match="caption">
		<div class="table-caption">
			<xsl:apply-templates select="parent::table-wrap/label" mode="captionLabel" />
			<xsl:apply-templates />
		</div>
	</xsl:template>
	<xsl:template match="table-wrap/table">
		<div class="table-wrapper">
			<table>
				<xsl:attribute name="id">
					<xsl:value-of select="concat(name(.), '-', count(preceding::table)+1)" />
				</xsl:attribute>
				<xsl:apply-templates select="@* | node() " />
			</table>
		</div>
	</xsl:template>
	<!-- Handle other parts of table -->
	<xsl:template match="thead|tbody|th|td|tr">
		<xsl:variable name="name" select="name(.)" />
		<xsl:variable name="elementCount" select="count(preceding::*[name()=$name])+1" />
		<xsl:copy>
			<xsl:attribute name="id">
				<xsl:value-of select="concat($name, '-', $elementCount)" />
			</xsl:attribute>
			<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>
	<!-- Handle Table FootNote -->
	<xsl:template match="table-wrap-foot">
		<div class="table-foot">
			<ul class="table-footnotes">
				<xsl:apply-templates />
			</ul>
		</div>
	</xsl:template>
	<xsl:template match="table-wrap-foot/fn">
		<li class="fn" id="{concat('fn-', count(preceding::fn)+1)}">
			<xsl:apply-templates />
		</li>
	</xsl:template>

	<!-- END Table Handling -->

	<!-- Start Figure Handling -->
	<!-- fig with atrtribute specific-use are supplement figures -->
	
	<!-- NOTE: PATH/LINK to be replaced -->
	<xsl:template match="fig-group">
		<div class="fig-group" id="{concat('fig-group-', count(preceding::fig-group)+1)}">
			<div id="{child::fig[not(@specific-use)]/@id}" class="fig-inline-img-set fig-inline-img-set-carousel">
				<div class="elife-fig-slider-wrapper eLifeArticleFiguresSlider-processed">
					<div class="elife-fig-slider">
						<div class="elife-fig-slider-img elife-fig-slider-primary">
						
							<!-- use variables to set src and alt -->
							
							<xsl:variable name="primarysrc" select="concat('http://cdn-site.elifesciences.org/content/elife/4/',child::fig[not(@specific-use)]/@id, '.gif')"/>
							<xsl:variable name="primarycap" select="child::fig[not(@specific-use)]//label/text()"/>
							<img data-fragment-nid="" class="figure-icon-fragment-nid-" src="{$primarysrc}" alt="{$primarycap}"/>
						</div>
						<div class="figure-carousel-inner-wrapper">
							<div class="figure-carousel figure-carousel-">
								<xsl:for-each select="child::fig[@specific-use]">
									<!-- use variables to set src and alt -->
									<xsl:variable name="secondarysrc" select="concat('http://cdn-site.elifesciences.org/content/elife/4/',@id, '.gif')"/>
									<xsl:variable name="secondarycap" select="child::label/text()"/>
									<div class="elife-fig-slider-img elife-fig-slider-secondary">
										<img data-fragment-nid="" class="figure-icon-fragment-nid-" src="{$secondarysrc}" alt="{$secondarycap}"/>
									</div>
								</xsl:for-each>
							</div>
						</div>
					</div>
				</div>
				<div class="elife-fig-image-caption-wrapper">
					<xsl:apply-templates />
				</div>
			</div>
		</div>
	</xsl:template>
	
	<!-- individual fig in fig-group -->
	
	<xsl:template match="fig-group/fig">
		<xsl:variable name="caption" select="child::label/text()"/>
		<div xmlns:xhtml="http://www.w3.org/1999/xhtml" class="highwire-markup" data-fragment-nid="">
			<div xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" id="content-block-markup">
				<div class="fig-expansion " id="{@id}">
					<span class="highwire-journal-article-marker-start"></span>
					<div class="fig-inline-img">
						<a href="" class="colorbox colorbox-load figure-expand-popup init-colorbox-processed cboxElement">
							<img src="http://cdn-site.elifesciences.org/content/elife/4/{@id}.gif" data-img="{@id}.gif" alt="{$caption}"/>
						</a>
					</div>
					<xsl:apply-templates />
					<span class="highwire-journal-article-marker-end"></span>
				</div>
				<span id="related-urls"></span>
			</div>
		</div>
	</xsl:template>
	
	<!-- fig caption -->
	<xsl:template match="fig-group//caption">
		<div class="fig-caption">
			<!-- three options -->
			<span class="elife-figure-links">
				<span class="elife-figure-link elife-figure-link-download">
					<a href="http://cdn-site.elifesciences.org/content/elife/4/{../@id}.jpg?download=true">Download figure</a>
				</span>
				<span class="elife-figure-link elife-figure-link-newtab">
					<a href="http://cdn-site.elifesciences.org/content/elife/4/{../@id}.jpg" target="_new">Open in new tab</a>
				</span>
				<span class="elife-figure-link elife-figure-link-ppt">
					<a href="">Download powerpoint</a>
				</span>
			</span>
			<span class="fig-label">
				<xsl:value-of select="../label/text()"/>
			</span>
			<xsl:apply-templates />
		</div>
		<div class="sb-div caption-clear"></div>
	</xsl:template>
	
	<xsl:template match="fig-group//caption/title">
		<span class="caption-title">
			<xsl:apply-templates />
		</span>
	</xsl:template>
	
	<xsl:template match="fig-group//ext-link">
		<a href="{@xlink:href}">
			<xsl:apply-templates />
		</a>
	</xsl:template>
	
	<!-- reset unwanted -->
	<xsl:template match="fig-group//object-id|fig-group//graphic"/>
	
	<!-- END Figure Handling -->
	
	<!-- STARTED By Lingasamy. S -->
	
	<!-- Acknowledgement -->
	
	<xsl:template match="ack">
		<div class="ctools-collapsible-container ctools-collapsible-processed">
			<span class="ctools-toggle"></span>
			<xsl:apply-templates />
		</div>
	</xsl:template>
	
	<xsl:template match="ack/title">
		<h2 class="pane-title ctools-collapsible-handle">
			<xsl:apply-templates />
		</h2>
	</xsl:template>
	
	<xsl:template match="ack/p">
		<div class="ctools-collapsible-content">
			<div xmlns="http://www.w3.org/1999/xhtml" class="section ack" id="ack-1" xmlns:xhtml="http://www.w3.org/1999/xhtml">
				<p>
					<xsl:attribute name="id">
						<xsl:value-of select="concat('p-', count(preceding::p)+1)" />
					</xsl:attribute>
					<xsl:apply-templates />
				</p>
			</div>
			<a class="back-to-top visible-small" href="#body-top">To Top</a>
		</div>
	</xsl:template>
	<!-- START Reference Handling -->
	
	<xsl:template match="ref-list">
		<div id="references" class="ctools-collapsible-container ctools-collapsible-processed">
			<span class="ctools-toggle"></span>
			<h2 class="pane-title ctools-collapsible-handle">References</h2>
			<div class="ctools-collapsible-content">
				<div class="elife-reflinks-sortby">
					<div class="elife-reflinks-sortby-label">Sort by:</div>
					<div class="item-list">
						<ul class="tabs inline elife-reflinks-sort-tabs">
							<li class="first"><span class="elife-reflinks-sort-tab selected"><a href="#elife-reflinks" data-ref="original" data-type="int" data-sort="asc" class="active">original order</a></span></li>
							<li><span class="elife-reflinks-sort-tab not-selected"><a href="#elife-reflinks" data-ref="author" data-type="string" data-sort="asc">author</a></span></li>
							<li><span class="elife-reflinks-sort-tab not-selected"><a href="#elife-reflinks" data-ref="title" data-type="string" data-sort="asc">title</a></span></li>
							<li><span class="elife-reflinks-sort-tab not-selected"><a href="#elife-reflinks" data-ref="date" data-type="date" data-sort="asc">year</a></span></li>
							<li class="last"><span class="elife-reflinks-sort-tab not-selected"><a href="#elife-reflinks" data-ref="cited" data-type="int" data-sort="asc">cited in paper</a></span></li>
						</ul>
					</div>
				</div>
				<div class="elife-reflinks-links">
					<xsl:apply-templates />
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="ref-list/title"/>
	
	<xsl:template match="ref">
		<article class="elife-reflinks-reflink" id="{@id}">
			<!-- set attribute -->
			<xsl:variable name="slno" select="translate(@id,'bib','')"/>
			<div class="elife-reflink-indicators">
				<div class="elife-reflink-indicators-left">
					<div class="elife-reflink-indicator-number">
						<span data-counter="{$slno}">
							<xsl:value-of select="$slno"/>
						</span>
					</div>
					<div class="elife-reflink-indicator-cm">
						<a href="#"></a>
					</div>
				</div>
				<div class="elife-reflink-indicators-right">
					<div class="elife-reflink-indicator-elife"></div>
					<div class="elife-reflink-indicator-oa"></div>
				</div>
			</div>
			<xsl:apply-templates />
		</article>
	</xsl:template>
	
	<xsl:template match="ref/element-citation">
		<xsl:variable name="refid" select="../@id"/>
		<div class="elife-reflink-main">
			<cite class="elife-reflink-title">
				<a href="">
					<span class="nlm-article-title" data-hwp-id="article-title-2">
						<xsl:value-of select="child::article-title"/>
					</span>
				</a>
			</cite>
			
			<!-- call authors template -->
			<!-- <xsl:call-templates select="authors"></xsl:call-templates>-->
			
			<xsl:if test="person-group[@person-group-type='author']">
				<div class="elife-reflink-authors">
					<xsl:for-each select="person-group[@person-group-type='author']">
						<xsl:for-each select="child::name">
							<xsl:variable name="givenname" select="child::given-names"/>
							<xsl:variable name="surname" select="child::surname"/>
							<xsl:variable name="fullname" select="concat($givenname, ' ', $surname)"/>
							<xsl:variable name="hrefvalue" select="concat('http://scholar.google.com/scholar?q=&quot;author:',$fullname,'&quot;')"/>
							<span class="elife-reflink-author">
								<a href="{$hrefvalue}">
									<xsl:value-of select="$fullname"/>
								</a>
							</span>
							<!-- if next name exists then add comma(,) -->
							<xsl:if test="following-sibling::name">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
				</div>
			</xsl:if>
			
			<xsl:if test="person-group[@person-group-type='editor']">
				<div class="elife-reflink-editors">
					<xsl:for-each select="person-group[@person-group-type='editor']">
						<xsl:for-each select="child::name">
							<xsl:variable name="givenname" select="child::given-names"/>
							<xsl:variable name="surname" select="child::surname"/>
							<xsl:variable name="fullname" select="concat($givenname, ' ', $surname)"/>
							<xsl:variable name="hrefvalue" select="concat('http://scholar.google.com/scholar?q=&quot;author:',$fullname,'&quot;')"/>
							<span class="elife-reflink-editor">
								<a href="{$hrefvalue}">
									<xsl:value-of select="$fullname"/>
								</a>
							</span>
							<!-- if next name exists then add comma(,) -->
							<xsl:if test="following-sibling::name">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
				</div>
			</xsl:if>
			
			
			<!-- call details template -->
			<!--<xsl:call-templates select="details"></xsl:call-templates>-->
			
			<!-- move all other elements into details div 
				and comma separate
			-->
			<div class="elife-reflink-details">
				<xsl:if test="child::source">
					<span class="elife-reflink-details-journal">
						<span class="nlm-source" data-hwp-id="source-1">
							<xsl:apply-templates select="child::source/node()"/>
						</span>
					</span>
					<xsl:if test="child::source/following-sibling::*">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:if test="child::volume">
					<span class="elife-reflink-details-volume">
						<xsl:apply-templates select="child::volume/node()"/>
					</span>
					<xsl:if test="child::volume/following-sibling::*">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:if test="child::fpage">
					<span class="elife-reflink-details-pages">
						<xsl:apply-templates select="child::fpage/node()"/>
						<xsl:if test="child::lpage">
							<xsl:text>-</xsl:text>
							<xsl:value-of select="child::lpage/text()"/>
						</xsl:if>
					</span>
					<xsl:if test="child::fpage/following-sibling::*">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:if test="child::year">
					<span class="elife-reflink-details-year">
						<xsl:apply-templates select="child::year/node()"/>
					</span>
				</xsl:if>
				<xsl:if test="child::pub-id">
					<xsl:variable name="doivalue" select="child::pub-id/node()"></xsl:variable>
					<div class="elife-reflink-doi-cited-wrapper">
						<span class="elife-reflink-details-doi">
							<a href="{concat('http://dx.doi.org/', $doivalue)}">
								<xsl:value-of select="concat('http://dx.doi.org/', $doivalue)"/>
							</a>
						</span>
						<!-- count no.of cited -->
						<xsl:text> — </xsl:text>
						<span class="elife-reflink-details-cited">
							<xsl:value-of select="concat('cited ', count(preceding::xref[@rid=$refid]), ' times in paper')"/>
						</span>
					</div>
					<div class="elife-reflink-links-wrapper">
						<span class="elife-reflink-link life-reflink-link-ijlink">
							<a href="" target="_blank" rel="nofollow">HighWire</a>
						</span>
						<span class="elife-reflink-link life-reflink-link-doi">
							<a href="" target="_blank" rel="nofollow">CrossRef</a>
						</span>
						<span class="elife-reflink-link life-reflink-link-medline">
							<a href="" target="_blank" rel="nofollow">PubMed</a>
						</span>
					</div>
				</xsl:if>
			</div>
			<xsl:apply-templates />
		</div>
	</xsl:template>
	
	<!-- reset unwanted -->
	<xsl:template match="ref//year|ref//article-title|ref//fpage|ref//volume|ref//source|ref//pub-id|ref//lpage|ref//comment|ref//supplement"/>
	
	<!-- reference authors -->
	<xsl:template match="person-group[@person-group-type='author']"/>
	
	<!--<xsl:template match="person-group[@person-group-type='author']" name="authors">
		<div class="elife-reflink-authors">
			<xsl:for-each select="child::name">
				<xsl:variable name="givenname" select="child::given-names"/>
				<xsl:variable name="surname" select="child::surname"/>
				<xsl:variable name="fullname" select="concat($givenname, ' ', $surname)"/>
				<xsl:variable name="hrefvalue" select="concat('http://scholar.google.com/scholar?q=&quot;author:',$fullname,'&quot;')"/>
				<span class="elife-reflink-author">
					<a href="{$hrefvalue}">
						<xsl:value-of select="$fullname"/>
					</a>
				</span>-->
				<!-- if next name exists then add comma(,) -->
				<!--<xsl:if test="following-sibling::name">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:template>-->
	<!-- END Reference Handling -->

	<!-- START video handling -->
	
	<xsl:template match="media">
		<div class="media video-content">
			<!-- set attribute -->
			<xsl:attribute name="id">
                <xsl:value-of select="concat('media-', @id)"/>
            </xsl:attribute>
			<div class="media-inline video-inline">
				<div class="elife-inline-video">
					<video controls="controls" poster="{@xlink:href}" preload="none" style="background-color:black">
						<source src="{@xlink:href}" type="video/mp4; codecs=&quot;avc1.42E01E, mp4a.40.2&quot;"/>
						<source src="{@xlink:href}" type="video/ogg; codecs=&quot;theora, vorbis&quot;"/>
						<img src="{@xlink:href}"/>
						<xsl:text>Your browser does not appear to support HTML5 video. Please upgrade your browser.</xsl:text>
					</video>
					<div class="elife-video-links">
						<span class="elife-video-link elife-video-link-download">
							<a href="{@xlink:href}">Download Video </a>
						</span>
					</div>
				</div>
			</div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<!-- media caption -->
	<xsl:template match="//media/caption">
		<div class="media-caption">
			<span class="media-label">
				<xsl:value-of select="preceding-sibling::label"/>
			</span>
			<xsl:text> </xsl:text>
			<span class="caption-title">
				<xsl:if test="child::title">
					<xsl:call-templates select="child::title"/>
				</xsl:if>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="//media/label"/>
	
	<xsl:template match="//media//title">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- END video handling -->
	
	<!-- START sub-article -->
	
	<xsl:template match="sub-article">
		<div class="ctools-collapsible-container ctools-collapsible-processed">
			<!-- determine the attribute -->
			<xsl:attribute name="id">
				<xsl:if test="@article-type='article-commentary'">
					<xsl:text>decision-letter</xsl:text>
				</xsl:if>
				<xsl:if test="@article-type='reply'">
					<xsl:text>author-response</xsl:text>
				</xsl:if>
			</xsl:attribute>
			<span class="ctools-toggle"></span>
			
			<xsl:call-templates name="subarticle-title"/>
			
			<div class="ctools-collapsible-content">
				<div>
					<!-- determine the attribute -->
					<xsl:attribute name="id">
						<xsl:if test="@article-type='article-commentary'">
							<xsl:text>decision_letter</xsl:text>
						</xsl:if>
						<xsl:if test="@article-type='reply'">
							<xsl:text>author_response</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:apply-templates/>
				</div>
				<a class="back-to-top visible-small" href="#body-top">To Top</a>
			</div>
		</div>
		<div class="panel-separator"></div>
	</xsl:template>
	
	<!-- sub article title h2 -->
	<xsl:template match="sub-article//title-group" name="subarticle-title">
		<h2 class="pane-title ctools-collapsible-handle">
			<xsl:apply-templates/>
		</h2>
	</xsl:template>
	
	<xsl:template match="sub-article//article-title">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="sub-article/front-stub">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- sub-article body -->
	<xsl:template match="sub-article/body">
		<div>
			<!-- determine the class based on attribute -->
			<xsl:attribute name="class">
				<xsl:if test="../@article-type='article-commentary'">
					<xsl:text>elife-article-decision-letter</xsl:text>
				</xsl:if>
				<xsl:if test="../@article-type='reply'">
					<xsl:text>elife-article-author-response</xsl:text>
				</xsl:if>
			</xsl:attribute>
			<div class="highwire-markup">
				<div xmlns="http://www.w3.org/1999/xhtml" id="content-block" xmlns:xhtml="http://www.w3.org/1999/xhtml">
					<div class="article fulltext-view ">
						<span class="highwire-journal-article-marker-start"></span>
						<xsl:apply-templates/>
						<span class="highwire-journal-article-marker-end"></span>
					</div>
					<span id="related-urls"></span>
				</div>
			</div>
		</div>
		<div>
			<xsl:attribute name="class">
				<xsl:if test="../@article-type='article-commentary'">
					<xsl:text>elife-article-decision-letter-doi</xsl:text>
				</xsl:if>
				<xsl:if test="../@article-type='reply'">
					<xsl:text>elife-article-author-response-doi</xsl:text>
				</xsl:if>
			</xsl:attribute>
			<strong>DOI: </strong>
			<a href="">
				<xsl:value-of select="preceding-sibling::*//article-id"/>
			</a>
		</div>
	</xsl:template>
	
	<xsl:template match="sub-article//article-id"/>
	
	<!-- START sub-article author contrib information -->
	
	<xsl:template match="sub-article//contrib-group">
		<div class="elife-article-editors">
			<xsl:apply-templates />
		</div>
	</xsl:template>
	
	<xsl:template match="sub-article//contrib-group/contrib">
		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('elife-article-decision-revewing', @contrib-type)" />
			</xsl:attribute>
			<xsl:apply-templates />
		</div>
	</xsl:template>
	
	<xsl:template match="sub-article//name|sub-article//aff">
		<xsl:apply-templates />
		<xsl:if test="following-sibling::*">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="sub-article//surname">
		<span class="nlm-surname">
			<xsl:apply-templates />
		</span>
	</xsl:template>
	
	<xsl:template match="sub-article//given-names">
		<span class="nlm-given-names">
			<xsl:apply-templates />
		</span>
	</xsl:template>
	
	<xsl:template match="sub-article//role">
		<span class="nlm-role">
			<xsl:apply-templates />
		</span>
		<xsl:if test="following-sibling::*">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="sub-article//institution">
		<span class="nlm-institution">
			<xsl:apply-templates />
		</span>
	</xsl:template>
	
	<xsl:template match="sub-article//country">
		<span class="nlm-country">
			<xsl:apply-templates />
		</span>
		<xsl:if test="following-sibling::*">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<!-- END sub-article author contrib information -->
	
	<!-- box text -->
	<xsl:template match="boxed-text">
		<div class="boxed-text">
			<xsl:attribute name="id">
				<xsl:value-of select="concat('boxed-text-', count(preceding::boxed-text)+1)" />
			</xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<!-- START - general format -->
	
	<xsl:template match="bold">
		<strong>
			<xsl:apply-templates/>
		</strong>
	</xsl:template>
	
	<xsl:template match="italic">
		<em>
			<xsl:apply-templates/>
		</em>
	</xsl:template>
	
	<!-- END - general format -->
	
	<!-- nodes to remove -->
	<xsl:template match="object-id|table-wrap/label" />
	
	
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="elife07370.xml" htmlbaseurl="" outputurl="elife07370.html" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength=""
		          urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
		          customvalidator="">
			<advancedProp name="sInitialMode" value=""/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bSchemaAware" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="xsltVersion" value="2.0"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->