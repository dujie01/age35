from pyecharts.charts import Geo
from pyecharts.charts import Map
from pyecharts import options as opts
import pandas as pd
from pyecharts.globals import ChartType
from pyecharts import options as opts

path = '~/staylocally_change.csv' 
data = pd.read_csv(io = path)
data = data.dropna()

geo = Geo(init_opts=opts.InitOpts(width="2400px",height='1200px'),is_ignore_nonexistent_coord=True)
geo.add_schema(maptype='china',
               itemstyle_opts=opts.ItemStyleOpts(color='white',border_color='#111')) 
geo.add('',data_pairs_big,label_opts=opts.LabelOpts(is_show=False),type_=ChartType.EFFECT_SCATTER)
geo.set_global_opts(#title_opts=opts.TitleOpts(title='',subtitle='',pos_left= '45%',pos_top='80'),
    visualmap_opts=opts.VisualMapOpts(
                    min_=value_min_big,
                    max_=value_max_big, is_piecewise=True,
                    pieces=[{"max":-0.24, "min": -0.6, "label": "-0.6~-0.24", "color": "#FF6666"},   
                            {"max": 0, "min": -0.25, "label": "-0.25~0.00", "color": "#FFEADD"},
                            {"max": 0.25, "min": 0.01, "label": "0.01~0.25", "color": "#E4F1FF"},
                            {"max": 0.6, "min": 0.26, "label": "0.26~0.6", "color": "#62CDFF"}
                            ],
                   pos_left = '35%',pos_top='700'
                ) 
                   )#1 ['#D71313','#FFE17B','#279EFF']))   2 range_color=['#D71313','#D8D9DA','#0E21A0'])
#                     range_color=['#B9EDDD','#FFE17B','#D71313']))  #orangered  range_color=['lightskyblue','yellow','red']))
geo.render('35_age.html')
