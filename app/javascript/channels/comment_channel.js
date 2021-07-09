import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const post_element = document.getElementById('post-id-comments');
  const user_element = document.getElementById('user-id-comments');
	
	if (post_element) {
		const post_id = post_element.getAttribute('data-post-id');
		const user_id = user_element.getAttribute('data-user-id');

		consumer.subscriptions.subscriptions.forEach((subscription) => {
			if (JSON.parse(subscription.identifier).channel == 'CommentChannel')
				consumer.subscriptions.remove(subscription)
		})

		consumer.subscriptions.create({ channel: "CommentChannel", post_id: post_id }, {
			connected() {
				// Called when the subscription is ready for use on the server
			},

			disconnected() {
				// Called when the subscription has been terminated by the server
			},

			received(data) {
				if(data["type"] == "comment"){
					this.processCommentActions(data);
				} else if(data["type"] == "reaction") {
					this.processReactionActions(data);
				} else if(data["type"] == "post") {
					this.processPostActions(data);
				}
			},

			processPostActions(data){
				if(data["action"] == "update") {			
					this.updatePostBreadcrumbTitle(data);
				} else if(data["action"] == "destroy") {
					this.removePostBreadcrumb();
					this.removeCommentsSection();
					this.appendDeletedNotice();
				}
			},

			updatePostBreadcrumbTitle(data){
				var element = document.getElementById("post-title-link");
				if(element && data["title"]){
					element.innerHTML = data["title"];
				}
			},

			removePostBreadcrumb(){
				var element = document.getElementById("post-title-item");
				if(element){
					element.innerHTML = "This Post has been removed";
				}
			},

			appendDeletedNotice() {
				var element = document.getElementById("notice");
				if(element){
					element.innerHTML = "This Post has been removed by the user.";
				}
			},

			removeCommentsSection(){
				var element = document.getElementById("comments-section");
				if(element){
					element.remove();
				}
			},

			processReactionActions(data){
				if(data["owner_id"] == user_id){
					this.processReactionActionsForOwner(data);
				} else if(data["action"] == "reaction_render") {
					this.renderReaction(data);
				} else {
					if(data["action"] == "create" || data["action"] == "destroy") {
						this.updateReactionCount(data);
					}
				}
			},

			processReactionActionsForOwner(data){				
				if(data["action"] == "create" || data["action"] == "destroy") {
					this.perform("generate_reaction", data);
				}
			},

			renderReaction(data){
				var element = document.getElementById(data["data"]["reaction_type"]+"_comment_"+data["data"]["comment_id"]);
				var formElement;
				if(data["data"]["action"] == "create") {
					formElement = document.getElementById(data["data"]["reaction_type"]+"_create_form_comment_"+data["data"]["comment_id"]);
				} else {
					formElement = document.getElementById(data["data"]["reaction_type"]+"_delete_form_comment_"+data["data"]["reaction_id"]);
				}
				if (element && !formElement) {
					element.innerHTML = data["html"];
				}
			},

			updateReactionCount(data){
				if(data["comment_id"] && data["reaction_type"]){
					var element = document.getElementById("comment_"+data["comment_id"]+"_"+data["reaction_type"]+"_count");
					if(element && data["reaction_count"]){
						element.innerHTML = data["reaction_count"];
					}
				}
			},

			processCommentActions(data){
				if(data["action"] == "create") {
					this.perform("generate_comment", data);
				} else if(data["action"] == "comment_render") {
					this.appendComment(data);
				} else if(data["action"] == "update") {
					this.updateCommentDescription(data);
				} else if(data["action"] == "destroy") {					
					this.removeComment(data);
				}
			},


			updateCommentDescription(data){
				if(data["comment_id"]){
					var element = document.getElementById("comment_"+data["comment_id"]+"_description");
					if(element && data["description"]){
						element.innerHTML = data["description"];
					}
				}
			},

			appendComment(data){
				var element = document.getElementById("post_comments");
				if(element){
			  	var commentRow = document.getElementById("comment_row_"+data["data"]["comment_id"]);
					if(!commentRow){
						element.insertAdjacentHTML('afterbegin', data["html"]);
					}
				}
			},

			removeComment(data){
				if(data["comment_id"]){
					var element = document.getElementById("comment_row_"+data["comment_id"]);
					if(element){
						element.remove();
					}
				}
			}
		});
	}
})

