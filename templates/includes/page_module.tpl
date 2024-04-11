<div class="box box-element" data-type="{$data_type|default:'n/a'}">
   <a href="#close" class="remove btn btn-danger btn-xs"><i class="glyphicon glyphicon-remove"></i></a>
   <a class="drag btn btn-default btn-xs"><i class="glyphicon glyphicon-move"></i></a>
   {if isset($has_setting)}
   <span class="configuration">
      <a class="btn btn-xs btn-warning settings" href="javascript:;" ><i class="fa fa-gear"></i></a>
   </span>
   {/if}
   <div class="preview">
      <i class="fa {$module_icon|default:'fa-question'} fa-2x"></i>
      <div class="element-desc">{$module_title|default:'n/a'}</div>
   </div>
   <div class="view">
   {if isset($html_code)}
      {$html_code}
   {elseif isset($template)}
      {include file=$template}
   {else}
      Template Not Set
   {/if}
   </div>
</div>