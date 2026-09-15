'use strict';
'require view';
'require fs';
'require ui';

/*
 * luci-app-itv  ---  client-side view
 *
 * Serves up to four channel lists from /www/tvN, reachable at
 * http://<router>/tvN by players such as DIYP or 超级直播.
 *
 * A channel pane is only offered when its backing file exists, preserving the
 * behaviour of the original Lua app: delete /www/tvN to retire that slot.
 */

const CHANNELS = [
	{ id: 1, icon: '📕' },
	{ id: 2, icon: '📗' },
	{ id: 3, icon: '📘' },
	{ id: 4, icon: '📙' }
];

function pathOf(id) {
	return '/www/tv%d'.format(id);
}

function urlOf(id) {
	return 'http://<router>/tv%d'.format(id);
}

return view.extend({
	load: function() {
		return Promise.all(CHANNELS.map(function(ch) {
			return fs.read(pathOf(ch.id)).then(function(text) {
				return { ch: ch, text: text, present: true };
			}).catch(function() {
				return { ch: ch, text: '', present: false };
			});
		}));
	},

	render: function(states) {
		const present = states.filter(function(s) { return s.present; });

		if (present.length === 0)
			return E('div', { 'class': 'cbi-section' }, [
				E('p', {}, _('No channel list found. Expected /www/tv1 ... /www/tv4.')),
				E('p', {}, _('Reinstall the package, or create one of these files manually.'))
			]);

		const panes = present.map(function(s, i) {
			const path = pathOf(s.ch.id);
			const status = E('span', { 'class': 'ifacebadge' }, ' ');
			let area = null;

			area = E('textarea', {
				'rows': 20,
				'wrap': 'off',
				'spellcheck': 'false',
				'style': 'width:100%;font-family:monospace;white-space:pre',
				'input': function() {
					status.textContent = (area.value === s.text) ? ' ' : _('modified');
				}
			}, s.text);

			return E('div', {
				'data-tab': 'tv%d'.format(s.ch.id),
				'data-tab-title': '%s TV%d'.format(s.ch.icon, s.ch.id),
				'data-tab-active': (i === 0) ? 'true' : null
			}, [
				E('p', {}, [
					_('Player URL: '),
					E('strong', {}, urlOf(s.ch.id)),
					' — ',
					_('one channel per line, in the format your player expects.')
				]),
				area,
				E('div', { 'class': 'cbi-page-actions' }, [
					E('button', {
						'class': 'cbi-button cbi-button-apply',
						'click': ui.createHandlerFn(this, function() {
							const value = area.value.replace(/\r\n?/g, '\n');

							if (value === s.text) {
								ui.addNotification(null,
									E('p', {}, _('Nothing to save in %s.').format(path)), 'info');
								return;
							}

							return fs.write(path, value).then(function() {
								s.text = value;
								status.textContent = ' ';
								ui.addNotification(null,
									E('p', {}, _('Saved %s.').format(path)), 'info');
							});
						})
					}, _('Save')),
					' ',
					E('button', {
						'class': 'cbi-button cbi-button-reset',
						'click': function() {
							area.value = s.text;
							status.textContent = ' ';
						}
					}, _('Reset'))
				]),
				E('p', {}, status)
			]);
		}, this);

		return E('div', { 'class': 'cbi-map' }, [
			E('h2', {}, _('📺 iTV channel sources')),
			E('div', { 'class': 'cbi-map-descr' },
				_('The router serves each list over HTTP for IPTV players such as DIYP or 超级直播. ' +
				  'Classification headers must follow the format the player expects, ' +
				  'otherwise the whole list is ignored.')),
			E('div', {}, panes)
		]);
	}
});
