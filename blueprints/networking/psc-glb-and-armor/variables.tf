/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "consumer_project_id" {
  description = "The consumer project, in which the GCLB and Cloud Armor should be created."
  type        = string
}

variable "prefix" {
  description = "Prefix used for resource names."
  type        = string
  default     = null
}

variable "producer_a_project_id" {
  description = "The producer A project, in which the LB, PSC Service Attachment and Cloud Run service should be created."
  type        = string
}

variable "producer_b_project_id" {
  description = "The producer B project, in which the LB, PSC Service Attachment and Cloud Run service should be created."
  type        = string
}

variable "project_create_config" {
  description = "Create project instead of using an existing one."
  type = object({
    billing_account = string
    parent          = optional(string)
  })
  default = null
}

variable "region" {
  description = "The GCP region in which the resources should be deployed."
  type        = string
}
