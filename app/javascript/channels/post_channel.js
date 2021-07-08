import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const post_element = document.getElementById('post-id');
	if (post_element) {
		const post_id = post_element.getAttribute('data-post-id');

		consumer.subscriptions.subscriptions.forEach((subscription) => {
			if (JSON.parse(subscription.identifier).channel == 'PostChannel')
				consumer.subscriptions.remove(subscription)
		})

		consumer.subscriptions.create({ channel: "PostChannel", post_id: post_id }, {
			connected() {
				// Called when the subscription is ready for use on the server
			},

			disconnected() {
				// Called when the subscription has been terminated by the server
			},

			received(data) {
				if(data["action"] == "update") {
					this.updatePostTitle(data);
					this.updatePostBreadcrumbTitle(data);
					this.updatePostDescription(data);
				} else if(data["action"] == "destroy") {
					this.removePostLinks();
					let deletedParams = this.deletedParams();
					this.updatePostTitle(deletedParams);
					this.updatePostBreadcrumbTitle(deletedParams);
					this.updatePostDescription(deletedParams);
				}
			},

			updatePostBreadcrumbTitle(data){
				var element = document.getElementById('post-title-breadcrumb');
				if(element && data["title"]){
					element.innerHTML = data["title"];
				}
			},

			updatePostTitle(data){
				var element = document.getElementById('post-title');
				if(element && data["title"]){
					element.innerHTML = data["title"];
				}
			},

			updatePostDescription(data){
				var element = document.getElementById('post-description');
				if(element && data["description"]){
					element.innerHTML = data["description"];
				}
			},

			removePostLinks(){
				var element = document.getElementById('post-header');
				if(element){
					element.innerHTML = "";
				}
			},

			deletedParams(){
				let text = "This Post has been removed.";
				return {
					title: text,
					description: text
				};
			}
		});
	}
})

