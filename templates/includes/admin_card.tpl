<div class="col-lg-4 col-md-6 col-sm-12 col-xs-12">
	<!-- <div class="thumbnail">
		<div class="caption">
			<h4><span class="fa {$fa_icon|default:"fa-question-circle"}"</span> {$title|default:"No Title"}</h3>
			<p>{$desc|default:"No Description"}</p>
			<p><a href="{$href|default:"No HREF"}" class="btn btn-sm btn-success">{$title|default:"No Title"}</a></p>
		</div>
	</div> -->
	<a href="{$href|default:'No HREF'}">
		<div class="card-box bg-card">
			<span class="card-box-icon"><i class="fa {$fa_icon|default:'fa-question-circle'}"></i></span>

			<div class="card-box-content">
				<span class="card-box-text"> {$title|default:"No Title"}</span>
				<p class="ellipsis">{$desc|default:"No Description"}</p>
				<!-- <span class="card-box-number"><i class="fa fa-database"></i> 1,999</span> -->

				<div class="card-box-footer">
					<div class="card-progress">
						<div class="card-progress-bar" style="width: {$params.count|default:'0'}%"></div>
					</div>
					<span class="card-description-count m-r-10">
						<i class="fa fa-database"></i> {$params.count|default:"0"} {$metric|default:""}
					</span>
					{if !empty($params.date)}
					<span class="card-description-date m-r-10">
						<i class="fa fa-clock-o"></i> {$params.date|date_format:'%b'}{$params.date|date_format:" jS, "}{$params.date|date_format:'%Y'}
					</span>
					{/if}
					{if !empty($params.editor)}
					<span class="card-description-editor">
						<i class="fa fa-users"></i> {$params.editor}
					</span>
					{/if}
				</div>
			</div>
		</div>
	</a>
</div>